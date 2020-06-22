#!/bin/bash

#bash version이 NULL이 아니라면 참
#home/.bashrc 파일이 존재하는 파일이라면 참
#여기서 "$HOME… 앞의 .(콤마)는 해당 경로의 파일을 실행하거나 소스로 사용한다는 의미입니다.
if [ -n "$BASH_VERSION" ]; then 
    if [ -f "$HOME/.bashrc" ]; then 
	. "$HOME/.bashrc".
    fi
fi

#HOME/bin 디렉토리가 존재한다면,
#PATH 변수에 HOME/bin 경로를 저장합니다.
if [ -d "$HOME/bin" ] ; then 
    PATH="$HOME/bin:$PATH" 
fi

#만약 HOME/.local/bin 디렉토리가 존재한다면
#PATH에 해당 경로를 저장합니다.
if [ -d "$HOME/.local/bin" ] ; then 
    PATH="$HOME/.local/bin:$PATH"
fi


#Script1 정리
#.bashrc 파일 내 PATH변수의 경로를 바꾸는 코드입니다.
