#!/usr/bin/env zsh

# Пути к файлам с активными и отключенными плагинами
active_plugins_file="$HOME/.zsh_plugins"
disabled_plugins_file="$HOME/.zsh_plugins_disabled"

# Прочитать плагины из файлов, если они существуют
[[ -f $active_plugins_file ]] && plugins=($(<"$active_plugins_file"))
[[ -f $disabled_plugins_file ]] && disabled_plugins=($(<"$disabled_plugins_file"))

# Сохранение списка плагинов в файл
function save_to_file() {
    echo "$1" > "$2"
}

# Функция для показа меню пользователю
function show_menu() {
    echo "1) Список активных плагинов"
    echo "2) Список отключенных плагинов"
    echo "3) Включить плагин"
    echo "4) Отключить плагин"
    echo "5) Выйти"
    echo -n "Пожалуйста, введите ваш выбор: "
}

# Функция для отображения активных плагинов
function list_active_plugins() {
    echo "Активные плагины:"
    for plugin in "${plugins[@]}"; do
        echo "  $plugin"
    done
}

# Функция для отображения отключенных плагинов
function list_disabled_plugins() {
    echo "Отключенные плагины:"
    for plugin in "${disabled_plugins[@]}"; do
        echo "  $plugin"
    done
}

# Обновленная функция для включения плагина
function enable_plugin() {
    echo -n "Введите имя плагина для включения: "
    read plugin_name
    if [[ " ${disabled_plugins[*]} " == *" $plugin_name "* ]]; then
        disabled_plugins=(${disabled_plugins[@]/$plugin_name})
        plugins+=($plugin_name)
        plugins=($(echo "${plugins[@]}" | tr ' ' '\n' | awk '!a[$0]++' | tr '\n' ' '))
        save_to_file "${plugins[*]}" "$active_plugins_file"
        save_to_file "${disabled_plugins[*]}" "$disabled_plugins_file"
        echo "Плагин '$plugin_name' включен."
    else
        echo "Плагин '$plugin_name' не отключен или не существует."
    fi
}

# Обновленная функция для отключения плагина
function disable_plugin() {
    echo -n "Введите имя плагина для отключения: "
    read plugin_name
    if [[ " ${plugins[*]} " == *" $plugin_name "* ]]; then
        plugins=(${plugins[@]/$plugin_name})
        disabled_plugins+=($plugin_name)
        disabled_plugins=($(echo "${disabled_plugins[@]}" | tr ' ' '\n' | awk '!a[$0]++' | tr '\n' ' '))
        save_to_file "${plugins[*]}" "$active_plugins_file"
        save_to_file "${disabled_plugins[*]}" "$disabled_plugins_file"
        echo "Плагин '$plugin_name' отключен."
    else
        echo "Плагин '$plugin_name' не активен или не существует."
    fi
}

# Основной цикл программы
while true; do
    show_menu
    read choice
    case $choice in
        1) list_active_plugins ;;
        2) list_disabled_plugins ;;
        3) enable_plugin ;;
        4) disable_plugin ;;
        5) break ;;
        *) echo "Неверный вариант. Пожалуйста, попробуйте еще раз." ;;
    esac
    echo
done
