#!/bin/sh

# {PS1-}은 PS1이 존재하지 않는다면 '-'뒤에 있는 값을 나타냅니다.
# PS1값이 존재한다면, 존재하지않으면 빈 공간이므로 거짓입니다.
if [ "${PS-}" ]; then
	# BASH가 존재하면, 존재하지 않으면 빈공간이므로 거짓이 됩니다.
	# BASH의 값이 "/bin/sh"가 아니라면
	if [ "${BASH-}" ] && [ "BASH" != "/bin/sh" ]; then
		
		# /etc/bash.bashrc 파일이 존재한다면 해당 파일을 실행합니다.
		if [ -f /etc/bash.bashrc ]; then
			. /etc/bash.bashrc
		fi
	else
		# uid의 값을 찾는 명령 후 실행 후, uid의 값이 0이라면 [root를 의미]
		if [ "`id -u`" -eq 0 ]; then
			#PS1에 #을 대입합니다.
			PS1='# '
		# uid의 값이 0이 아니라면, [root가 아님을 의미]
		else
			PS1='$ '
		fi
	fi
fi

# /etc/profile.d 디렉토리가 존재한다면,
# /etc/pofile.d에 존재하는 스크립트 파일들 전부에 대해 반복문을 시행합니다.
# 반복문 내에서 파일을 읽을 수 있는 권한이 있으면, 파일을 실행합니다. 
# 이후 사용했던 변수를 해제합니다.
if [ -d /etc/profile.d ]; then
	for i in /etc/profile.d/*.sh; do
		if [ -r $i ]; then
			. $i
		fi
	done
	unset i
fi
#Script4 정리
#PS1(일차 명령 프롬프트), BASH 활성화 확인 후, 배쉬 설정 소스파일인 /.bashsrc 파일을 실행시키고, /etc/profile.d에 존재하는 모든 쉘 스크립트 파일을 실행시키는 코드입니다.

