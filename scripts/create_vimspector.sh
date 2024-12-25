#!/bin/zsh

# Папка с исходным кодом
PROJECT_DIR=$(pwd)

# Путь к файлу .vimspector.json
VIMSPECTOR_FILE="${PROJECT_DIR}/.vimspector.json"

# Проверка, существует ли файл
if [ -f "$VIMSPECTOR_FILE" ]; then
    echo "Файл .vimspector.json уже существует."
else
    echo "Создание .vimspector.json..."

    # Ищем скомпилированный исполняемый файл (по умолчанию a.out)
    EXEC_FILE=$(ls ${PROJECT_DIR} | grep -E '^a\.out$|[^/]*\.(out|bin|exe)$' | head -n 1)

    # Если файл не найден, сообщаем об этом
    if [ -z "$EXEC_FILE" ]; then
        echo "Не найден исполняемый файл для отладки."
        exit 1
    fi

    # Конфигурация для C/C++ с gdb
    cat <<EOL > "$VIMSPECTOR_FILE"
{
  "configurations": {
    "C Debug": {
      "adapter": "vscode-cpptools",
      "configuration": {
        "request": "launch",
        "program": "\${workspaceFolder}/$EXEC_FILE",
        "stopAtEntry": true,
        "cwd": "\${workspaceFolder}",
		"externalConsole": true,
		"console": "/bin/zsh",
        "MIMode": "gdb",
        "miDebuggerPath": "/usr/bin/gdb",
		"preLaunchTask": "build",
		"setupCommands": [
        {
          "text": "set print pretty on",
          "description": "Enable pretty printing for gdb",
          "ignoreFailures": false
        },
        {
          "text": "set env SHELL /bin/zsh",
          "description": "Set SHELL to /bin/zsh",
          "ignoreFailures": false
        },
        {
          "text": "set env LANG en_US.UTF-8",
          "description": "Set LANG to en_US.UTF-8",
          "ignoreFailures": false
        },
        {
          "text": "set env LC_CTYPE en_US.UTF-8",
          "description": "Set LC_CTYPE to en_US.UTF-8",
          "ignoreFailures": false
        },
		{
			"text": "set print elements 0"
		},
		{
			 "text": "set print object on"
		}
      ],
      "environment": [
        {
          "name": "SHELL",
          "value": "/bin/zsh"
        },
        {
          "name": "LANG",
          "value": "en_US.UTF-8"
        },
        {
          "name": "LC_CTYPE",
          "value": "en_US.UTF-8"
        }
      ]
    }
  }
}
}
EOL

    echo ".vimspector.json был успешно создан!"
fi

