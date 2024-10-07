# Define the directory where your scripts are located
SCRIPT_DIR := ./tasks

# List of script files
SCRIPTS := task1 task2 task3 task4 task5 task6 task7 task8 task9 task10 task11

# Default target: lists available scripts
all:
	@echo "Available tasks:"
	@echo "make task1   - Run task1"
	@echo "make task2   - Run task2"
	@echo "make task3   - Run task3"
	@echo "make task4   - Run task4"
	@echo "make task5   - Run task5"
	@echo "make task6   - Run task6"
	@echo "make task7   - Run task7"
	@echo "make task8   - Run task8"
	@echo "make task9   - Run task9"
	@echo "make task10  - Run task10"
	@echo "make task11  - Run task11"

# Targets for each script (you should put your arguments)
task1:
	@bash $(SCRIPT_DIR)/task1 ./assets/duplicate_files.zip
task2:
	@bash $(SCRIPT_DIR)/task2 ./assets/archive_1.zip
task3:
	@bash $(SCRIPT_DIR)/task3 dias 192.168.1.17
task4:
	@sudo bash $(SCRIPT_DIR)/task4 web-service-gin
task5:
	@bash $(SCRIPT_DIR)/task5 web-service-gin dev
task6:
	@bash $(SCRIPT_DIR)/task6
task7:
	@bash $(SCRIPT_DIR)/task7 dev
task8:
	@bash $(SCRIPT_DIR)/task8 ./assets/example.nomad $(job_name)
	# pass your value as job_name=example
task9:
	@bash $(SCRIPT_DIR)/task9
task10:
	@bash $(SCRIPT_DIR)/task10 192.168.1.17 web-server
task11:
	@bash $(SCRIPT_DIR)/task11
	
job_name ?= default
