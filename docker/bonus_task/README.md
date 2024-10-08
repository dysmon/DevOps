# Task: Fixing a Docker Image Issue

## Problem Statement
The Docker image pulled from Docker Hub encountered an issue where it fails immediately upon running. The task was to identify the root cause, resolve the issue, and push the corrected image back to Docker Hub.

## Analysis and Solution
1. **Investigating the Image Layers**:
   - Used the following command to inspect the image layers:
     ```bash
     docker history image_name
     ```
   - Found that the image was built without specifying a `FROM` keyword, which means it defaults to a `scratch` base image.
   - The image was attempting to run the command:
     ```json
     CMD ["cat", "/hello.txt"]
     ```
     However, since `scratch` is an empty base, it did not contain the `cat` command, leading to the failure.

2. **Extracting the Image for Further Inspection**:
   - Saved the Docker image to a tar file and extracted its contents to inspect the file structure:
     ```bash
     docker image save image_name > image.tar
     tar -xvf image.tar
     ```
   - Found the directory containing the `hello.txt` file by examining `index.json` for the relevant layer information.

3. **Fixing the Issue**:
   - Identified that the issue was due to the absence of a base image with basic utilities.
   - Built a new Dockerfile using `alpine` as the base image to provide the `cat` command and correct the issue:
     ```Dockerfile
     FROM alpine
     WORKDIR /app
     COPY hello.txt /hello.txt
     CMD ["cat", "/hello.txt"]
     ```

4. **Building and Testing the Fixed Image**:
   - Built the new image:
     ```bash
     docker build -t fixed_image_name .
     ```
   - Tested the image to ensure it runs correctly:
     ```bash
     docker run fixed_image_name
     ```
   - Verified that the `hello.txt` file is displayed correctly.

5. **Pushing the Fixed Image**:
   - Tagged and pushed the corrected image back to Docker Hub:
     ```bash
     docker tag fixed_image_name your_dockerhub_username/fixed_image_name
     docker push your_dockerhub_username/fixed_image_name
     ```

## Final Remarks
The issue was resolved by using a lightweight base image like `alpine` and ensuring that the necessary utilities were available. This approach made it possible for the `cat` command to execute successfully, displaying the contents of `hello.txt` as expected.

