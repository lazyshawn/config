#!/bin/bash
#------------------------------------------------------
# @author: lazyshawn
# @file  : spro.sh
# @brief : quickly create a workspace for multible project.
# @param : c, cc, py
# @ref   : RishabhRD/archrice: projectCreate
# @vers  : v.0.1
#------------------------------------------------------

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

  mkdir $projectName/doc
  mkdir $projectName/include
  mkdir $projectName/lib
  mkdir $projectName/src
  touch $projectName/src/main.cpp

  (
    echo "cmake_minimum_required(VERSION 3.15)"
    echo -e "project($projectName VERSION 1.0.0)\n"

    echo "SET(CMAKE_CXX_STANDARD 17)"
    echo "# Support degug"
    echo 'SET(CMAKE_CXX_FLAGS_DEBUG "$ENV{CXXFLAGS} -O0 -Wall -g2 -ggdb")'
    echo -e "#SET(CMAKE_CXX_FLAGS_RELEASE "$ENV{CXXFLAGS} -O3 -Wall")\n"

    echo "if(WIN32)"
    echo "  # create symbol for exporting lib for dynmic library"
    echo "  SET(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)"
    echo "  # control where the static and shared libraries are built so that on windows"
    echo "  # we don't need to tinker with the path to run the executable"
    echo '  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}")'
    echo '  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}")'
    echo '  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}")'
    echo "  # Build static in windows"
    echo "  option(BUILD_SHARED_LIBS "Build using shared libraries" OFF)"
    echo "  # Set the runtime lib for MSCV (global)"
    echo '  #set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")'
    echo "else()"
    echo '  option(BUILD_SHARED_LIBS "Build using shared libraries" ON)'
    echo -e "endif()\n"

    echo "# Set the installation directory"
    echo -e 'SET(CMAKE_INSTALL_PREFIX "${PROJECT_BINARY_DIR}/out/${PROJECT_NAME}-${CMAKE_BUILD_TYPE}")\n'

    echo "add_subdirectory(src)"
  ) > $projectName/CMakeLists.txt

  (
    echo "add_executable($projectName main.cpp)"
    echo "target_include_directories($projectName PUBLIC"
    echo "  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>"
    echo -e "  $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>\n)"
  ) > $projectName/src/CMakeLists.txt

  (
    echo "#include <iostream>"
    echo "int main(int argc, char** argv) {"
    echo '  printf("hello world\n");'
    echo "  return 0;"
    echo "}"
  ) > $projectName/src/main.cpp

  (
    echo "#!/bin/bash"
    echo 'if [[ -z $1 ]]; then'
    echo 'mkdir -p build'
    echo 'cd build'
    echo 'cmake ..'
    echo 'make'
    echo 'elif [[ "$1" == "install" ]]; then'
    echo 'mkdir -p build'
    echo 'cd build'
    echo 'cmake ..'
    echo 'make install'
    echo 'elif [[ "$1" == "debug" ]]; then'
    echo 'mkdir -p debug'
    echo 'cd debug'
    echo 'cmake -DCMAKE_BUILD_TYPE=Debug ..'
    echo 'make'
    echo 'elif [[ "$1" == "project" ]]; then'
    echo 'mkdir -p build'
    echo 'cd build'
    echo 'cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 ..'
    # echo 'cp compile_commands.json ..'
    echo 'fi'
  ) > $projectName/build.sh
  chmod u+x $projectName/build.sh
  ln -s ${PWD}/$projectName/build/compile_commands.json ${PWD}/$projectName/compile_commands.json

  (
    echo 'build/*'
    echo 'compile_commands.json'
    echo '.clangd/*'
    echo '.vs'
    echo 'out'
    echo 'data'
  ) > $projectName/.gitignore

  [ "$git_init" == "true" ] && git init $projectName
  cd $projectName && ./build.sh project
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
