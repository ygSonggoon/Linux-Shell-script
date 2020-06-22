#!/bin/bash

# PS1에 저장된 문자열 값이 NULL인 경우 종료합니다.
[ -z "$PS1" ] && return

# 배시창의 크기를 확인하고 환경 변수로 사용할 수 있게 합니다.
shopt -s checkwinsize		

# debinan_chroot의 값이 존재하지 않으면 '-'의 뒤에값 즉 빈공간을 나타나게 됩니다.
# debian_chroot가 NULL이며 시스템의 /etc/debian_chroot 파일을 읽을 수 있으면
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then

	# debian_chroot에는 해당 파일을 cat명령어를 통해 대입해줍니다.
	debian_chroot=$(cat /etc/debian_chroot)
fi

# SUDO_USER의 값이 NULL이며 SUDO_PS1의 값이 NULL이라면 참입니다.
#debian_chroot값이 존재한다면
# PS1는 "debian_chroot\유저\컴퓨터명\파일경로 $" 형태를 갖게 됩니다. 
if ! [ -n "${SUDO_USER}" -a -n "${SUDO_PS1}" ]; then
	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$ '
fi

#자동완성 기능을 활성화시키는 알려진 코드입니다.
#shopt -op 로 posix가 활성화 되어있는지 확인하고, 그렇다면 아래에서 
#bash_completion 파일의 경로를 확인 후
#해당 파일을 실행하여 기능을 활성화시킵니다.
if ! shopt -oq posix;  then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	
	
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

# /usr/lib/command-not-fount 또는 /usr/share/command-not-fount/command-not-found 
#프로세스가 실행 중이라면, command_not_found_handle함수를 정의합니다. 

#if
# /usr/lib/command-not-found 프로세스가 실행중인 경우
#-- 와 명령어창에서 받은 첫번째 인자 값을 해당 프로세스에게 넘겨줍니다. 이후
# /usr/lib/command-not-found가 어떻게 종료되었는지 return값으로 확인합니다.

#elif
# /usr/share/command-not-found/command-not-found 프로세스가 실행중인 경우
#-- 와 명령어창에서 받은 첫번째 인자 값을 해당 프로세스에게 넘겨줍니다. 이후
# /usr/share/command-not-found/command-not-found가 어떻게 종료되었는지 확인합니다.

#else
#그외 예상치 못한 상황 발생시, 분기를 합니다.	
# >&2 는 모든 출력을 표준 에러로 출력합니다, 
#이후 비정상 종료를 알리기 위해 127을 리턴합니다.
if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found/command-not-found ]; then
	function command_not_found_handle {
		if [ -x /usr/lib/command-not-found ]; then
			/usr/lib/command-not-found -- "$1"
			return $?
		elif [ -x /usr/share/command-not-found/command-not-found ]; then
			
			/usr/share/command-not-found/command-not-found -- "$1"
			
			return $?
		else.
			printf "$s: command not found\n" "$1" >&2
			return 127
		fi
	}
fi
#Script3 정리
#프롬프트명을 설정해줍니다. 이후 자동완성 기능을 활성화하고, 프로세스 내부에서 처리되어야 할 루틴함수(Command_not_found)를 정의합니다.
