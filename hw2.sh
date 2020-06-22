#!/bin/bash

#현재 옵션 플래그를 검사하고,
#만약 옵션 플래그에 i 문자가 존재한다면 코드 계속 진행하고 아니라면 프로그램을 종료합니다.
case $- in # $- 
    *i*) ;; 
      *) return;;
esac

#HINTCONTROL에 ignoreboth 플래그 입력 -> 쉘 히스토리에서 연속적으로 중복된 명령을 
#제거하는 옵션입니다.
HISTCONTROL=ignoreboth 

#shopt - 쉘 옵션 조회, 설정 도구, -s옵션으로 해당 옵션이 비지 않았다면 
#bash history관련 설정이 가능한 histappend 옵션을 활성화합니다.
shopt -s histappend 

#히스토리 명령 입력 시 1000개까지 출력합니다.
#~./bash_history 파일에 2000개까지 명령 저장이 가능하도록 설정합니다.
HISTSIZE=1000 
HISTFILESIZE=2000

#checkwinsize 옵션 추가 - 배시창의 크기를 확인하고 환경 변수로 사용할 수 있게 합니다.
#lines와 column변수 값을 업데이트하는 옵션입니다.
#와일드카드로 파일 집합 지정을 가능하게 하는 globstar옵션 추가합니다
shopt -s checkwinsize 
shopt -s globstar 

#lessipipe가 실행 중이라면 뒤의 SHELL변수를 선언합니다.
#eval 은 문자로 표현된 명령어를 실행시킵니다
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)" 

#변수 debian_chroot이 비어 있고, 뒤 경로의 debian_chroot파일의 읽기 권한이 있다면 #debian_chroot에 경로를 저장합니다.
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

#force_color_prompt 변수 스트링이 비지 않았는지 검사합니다. 0이 아니라면 참입니다.
#경로의 tput파일이 실행 중이라면 우측 명령어 실행하고,
# &/dev/null로 오류 메시지를 무시한다면 
#color_prompt 옵션을 활성화시킵니다.
if [ -n "$force_color_prompt" ]; then 
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then 
	color_prompt=yes
    else
	color_prompt=
    fi
fi

#color_prompt옵션 활성화 여부에 따라 프롬프트 표시기를 바꿉니다.
if [ "$color_prompt" = yes ]; then 
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

#경로의 dircolors가 실행중인 경우, /.dircolors 파일에 읽기 권한이 한 있는지 확인 후
#dircolors -b 명령어를 수행시킵니다. 해당 명령어는 GNU의 ls에서 color를 바꾸도록 합니다.
#alias명령어는 변수의 별칭을 정하는 명령어로 등호 왼쪽의 텍스트에 우측 텍스트를 매치시킵니다.
if [ -x /usr/bin/dircolors ]; then 
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto' 
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi



#상동
alias ll='ls -alF' 
alias la='ls -A'
alias l='ls -CF'

#마지막 명령 수행이 잘 되었다면 프롬프트에 terminal,그렇지 않다면 error를 출력합니다.
#수행했던 마지막 명령어를 잡고, 명령어를 편집하여 출력합니다.
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

#/.bash_aliases 파일이 정상적이라면,
#해당 파일을 실행시킵니다.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases 
fi


#자동완성 기능을 활성화시키는 알려진 코드입니다.
#shopt -op 로 posix가 활성화 되어있는지 확인하고, 그렇다면 
#아래에서 bash_completion 파일의 경로를 확인 후
#해당 파일을 실행하여 기능을 활성화시킵니다.
if ! shopt -oq posix; then 
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


#Script2 정리
#프롬프트 UI관련 설정을 지정하고, 옵션 명령어를 추가하며 자동완성 기능을 추가시키는 등, UI/UX 관련 설정을 지정하는 코드입니다.
