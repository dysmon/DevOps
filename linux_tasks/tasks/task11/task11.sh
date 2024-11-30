!/bin/bash

docker build -t api_for_11_task .

N=$1

# docker run -d --name api1 -p 9999:8000 api_for_11_task
# docker run -d --name api2 -p 9998:8000 api_for_11_task
# docker run -d --name api3 -p 9997:8000 api_for_11_task
# docker run -d --name api4 -p 9996:8000 api_for_11_task
# docker run -d --name api5 -p 9995:8000 api_for_11_task

BASE_PORT=9100
for ((i=1; i<=N; i++)); do
    port=$((BASE_PORT + i))
    docker run -d --name api$i -p $port:8000 api_for_11_task
done
sudo apt install -y socat

instances=()
for ((i=1; i<=N; i++)); do
    port=$((BASE_PORT + i))
    instances+=("http://127.0.0.1:$port")
done

# string
instances_str=$(IFS=","; echo "${instances[*]}")

# export the serialized instances array so it's available in the subshell
export instances_str

handle_request() {
    # instances=(
    #     "http://127.0.0.1:9999"
    #     "http://127.0.0.1:9998"
    #     "http://127.0.0.1:9997"
    #     "http://127.0.0.1:9996"
    #     "http://127.0.0.1:9995"
    # )
    # deserialize the instances array from the exported string
    IFS=',' read -r -a instances <<< "$instances_str"

    request_line=""
    headers=""
    while IFS=$'\r' read -r line; do
        line=${line%$'\r'}

        [ -z "$line" ] && break

        if [ -z "$request_line" ]; then
            request_line="$line"
        fi
        headers+="$line"$'\n'
    done

    echo "Received request: $request_line" >&2

    method=$(echo "$request_line" | awk '{print $1}')
    path=$(echo "$request_line" | awk '{print $2}')

    instance=${instances[RANDOM % ${#instances[@]}]}
    echo "Forwarding to: $instance$path" >&2

    if [ "$method" = "GET" ] || [ "$method" = "HEAD" ]; then
        response=$(curl -s -i -X "$method" "$instance$path")
    fi

    echo -e "$response"
}

export -f handle_request

# server
socat TCP-LISTEN:8014,reuseaddr,fork EXEC:/bin/bash\ -c\ handle_request
