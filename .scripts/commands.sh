#! /bin/bash

# A helper script to help build and upload firmware projects based on PlatformIO

function list_environments(){
  pio project config|grep ^env:|sed "s,env:,,"
}



function generate_vscode_tasks() {
  # Lists all environments, and creates a vscode build and upload tasks for each environment
  # This is useful for creating a vscode task.json file

  for env in $(list_environments); do
    echo "
    // Upload ${env}
    {
      \"label\": \"upload ${env}\",
      \"type\": \"shell\",
      \"command\": \"pio run -t upload -e ${env}\",
    },
    // Build ${env}
    {
      \"label\": \"build ${env}\",
      \"type\": \"shell\",
      \"command\": \"pio run -e ${env}\",
    },"
done
}

function update_vscode_tasks_json () {
  # Updates the vscode tasks.json file with the tasks generated by generate_vscode_tasks

  if [ ! -f .vscode/tasks.json ]; then
    echo "tasks.json file not found. Please run this command from the root of the project"
    exit 1
  fi

  # Backup the tasks.json file
  cp .vscode/tasks.json .vscode/tasks.json.bak

  # Create the top part
  echo ' {
  // This file is auto generated by the commands.sh script. Any edits will be overwritten automatically.
  "version": "2.0.0",
  "tasks": [

    // Build all
    {
      "label": "Build all",
      "type": "shell",
      "command": "pio run",
      "group": {
        "kind": "build",
        "isDefault": true
      }
    },

    // Make compiledb to allow LSP to work
    {
      "label": "Build compiledb database for LSP / clangd",
      "type": "shell",
      "command": "pio run -t compiledb",
    },
  ' > .vscode/tasks.json



  # Generate the tasks
  generate_vscode_tasks >> .vscode/tasks.json

  # Close the tasks.json file
  echo "] }" >> .vscode/tasks.json

  echo "tasks.json updated successfully"
}

function print_help() {
  echo "Usage: $0 <command>"
  echo "Commands:"
  echo "  list"
  echo "  show"
  echo "  build-all"
  echo "  build <environment>"
  echo "  upload <environment>"
  echo "  add_board"
  echo "  fzf_boards"
  echo "  update_vscode_tasks"
  exit 1
}

function build() {
  if [ $# -ne 1 ]; then
    echo "Usage: $0 build <environment>"
    echo "See list of available environments by running $0 list"
    exit 1
  fi

  pio run -e $1
}

function build_all() {
  pio run
}

function upload() {
  if [ $# -ne 1 ]; then
    echo "Usage: $0 upload <environment>"
    echo "See list of available environments by running $0 list"
    exit 1
  fi

  pio run -e $1 --target upload
}

function show() {
  pio project --list-targets
}

function fzf_boards() {
  # Fuzzy search boards and return the board id

  # Check if fzf installed
  if ! command -v fzf &> /dev/null; then
    echo "fzf is not installed. Please install fzf to use this feature."
    exit 1
  fi

  pio boards --json-output | jq -r '.[] | "id:" + .id + ", name:" + .name + ", platform:" + .platform' | fzf

}

# Gets new environemnt using fzf and adds it to the platformio.ini file
function add_new_board() {
  new_env=$(fzf_boards)
  if [ -z "$new_env" ]; then
    echo "No board selected. Exiting"
    exit 1
  fi
  echo "Adding new environment $new_env"

  # Get the board id
  board_id=$(echo $new_env | awk -F',' '{print $1}' | awk -F':' '{print $2}' | xargs)
  board_name=$(echo $new_env | awk -F',' '{print $2}' | awk -F':' '{print $2}' | xargs)
  board_platform=$(echo $new_env | awk -F',' '{print $3}' | awk -F':' '{print $2}' | xargs)

  # Add the new environment to the platformio.ini file
  echo "Adding new environment to platformio.ini"
  echo "
; $board_name
[env:$board_id]
platform = $board_platform
board = $board_id
; Additional build flags for $board_name here
build_flags =
  \${env.build_flags}
; Additional libraries for $board_name here
lib_deps =
  \${env.lib_deps}" >> platformio.ini

  update_vscode_tasks_json
}

function main() {
  # parse the command line arguments
  if [ $# -eq 0 ]; then
    print_help
    exit 1
  fi

  case $1 in
    list)
      list_environments
      ;;
    show)
      show
      ;;
    upload)
      shift
      upload $@
      ;;
    build-all)
      build_all
      ;;
    build)
      shift
      build $@
      ;;

    add_board)
      add_new_board
      ;;
    fzf_boards)
      fzf_boards
      ;;
    update_vscode_tasks)
      update_vscode_tasks_json
      ;;
    *)
      print_help
      exit 1
      ;;
  esac
}

main $@
