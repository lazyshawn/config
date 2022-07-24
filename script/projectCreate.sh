#!/bin/bash
# Breif:
#     quickly create a workspace for multible project.
#     C/C++, Python
# Author:
#     Lazyshawn
# Version:
#     v.0.1
# Reference:
#     RishabhRD/archrice: projectCreate

function help(){
  echo "usage: projectCreate -l lang -p projectName -c className"
  echo "optional : -g intialise a git repo inside project folder"
  echo "         : -h show this help message"
}
[[ -z $1 ]] && help

#############################################################################
# 解析命令行参数
#############################################################################
opts=$(getopt -o hgl: -l help,load,save,build::,clean -- "$@")
[ $? != 0 ] && exit 1
# 将$parameters设置为位置参数
eval set -- "$opts"
# 循环解析位置参数
while [ -n "$1" ]
do
  case "$1" in
    -h|--help)
      help
      shift;;
    -g)
      gitFlag='true'
      shift;;
    -l|--lang)
      lang="$2"
      shift 2;;
    # 开始解析非选项类型的参数，break后，它们都保留在$@中
    --)
      shift  # 偏移到--后的待处理参数
      break ;;
    *)
      help
      shift ;;
  esac
done
# 项目名称
projectName=$1
[ -z $1 ] && projectName="New Folder"

function git_init(){
  echo "git_init"
}

function py_init(){
  echo "Initializing Python3 project..."
  python3 -m venv ${projectName}
}

function cpp_init(){
  echo "Initializing C/C++ project..."
  
  mkdir $projectName/src
  mkdir $projectName/include
  mkdir $projectName/doc
  touch $projectName/src/main.cpp

  (
    echo "cmake_minimum_required(VERSION 2.8.9)"
    echo "project($projectName)"
    echo "include_directories(include)"
    echo 'file(GLOB_RECURSE SOURCES "src/*".cpp)'
    echo "add_executable($exe_name \${SOURCES})"
    echo "install(TARGETS $exe_name DESTINATION /usr/bin)"
  ) > $projectName/CMakeLists.txt

  (
    echo "#!/bin/bash"
    echo 'if [[ -z $1 ]]; then'
    echo 'mkdir -p bin'
    echo 'cd bin'
    echo 'cmake ..'
    echo 'make'
    echo 'elif [[ "$1" == "install" ]]; then'
    echo 'mkdir -p bin'
    echo 'cd bin'
    echo 'cmake ..'
    echo 'sudo make install'
    echo 'elif [[ "$1" == "debug" ]]; then'
    echo 'mkdir -p debug'
    echo 'cd debug'
    echo 'cmake -DCMAKE_BUILD_TYPE=Debug ..'
    echo 'make'
    echo 'elif [[ "$1" == "project" ]]; then'
    echo 'mkdir -p bin'
    echo 'cd bin'
    echo 'cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 ..'
    echo 'cp compile_commands.json ..'
    echo 'fi'
  ) > $projectName/build
  chmod u+x $projectName/build

  (
    echo 'bin/*'
    echo 'debug/*'
    echo 'compile_commands.json'
    echo '.vimspector.json'
    echo '.clangd/*'
  ) > $projectName/.gitignore

  (
    echo '{'
    echo '"configurations": {'
    echo '"Launch": {'
    echo '"adapter": "vscode-cpptools",'
    echo '"configuration": {'
    echo '"request": "launch",'
    echo "\"program\": \"debug/$exe_name\","
    echo "\"cwd\": \"`pwd`\"," >> .vimspector.json
    echo '"externalConsole": true,'
    echo '"MIMode": "gdb"'
    echo '}'
    echo '}'
    echo '}'
    echo '}'
  ) > $projectName/.vimspector.json

  [ "$git_init" == "true" ] && git init $projectName

  cd $projectName && ./build project
}

#############################################################################
# 创建项目文件夹
#############################################################################
### Get absolute path of the current directory
# Ref: https://stackoverflow.com/a/1638397
SCRIPTPATH=$(readlink -f "$0")
FOLDERPATH=$(dirname "$SCRIPTPATH")
PARENTPATH=$(dirname "$FOLDERPATH")

# 创建项目文件夹, 解决重名问题
while [ -e "${projectName}" ]
do
  projectName="${projectName}_"
done
mkdir "${projectName}" || exit 1

# 根据语言初始化项目
case $lang in
  py)
    py_init
    ;;
  c|cpp)
    cpp_init
    ;;
  *)
    echo "Unknow language type. An empty folder will be created."
    ;;
esac


# End of script
