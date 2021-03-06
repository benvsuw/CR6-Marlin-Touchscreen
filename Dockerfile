FROM ubuntu:latest as cr6-devel
RUN apt update -y && \
	apt install -y arduino-core curl git python3 python3-pip python3-venv python3-distutils udev unzip && \
	apt clean
RUN python3 -c "$(curl -fsSL https://raw.githubusercontent.com/platformio/platformio/master/scripts/get-platformio.py)" && \
	curl -fsSL https://raw.githubusercontent.com/platformio/platformio-core/master/scripts/99-platformio-udev.rules -o /lib/udev/rules.d/99-platformio-udev.rules
ENV	PATH="${PATH}:/root/.platformio/penv/bin"

WORKDIR /code
COPY Marlin /code/Marlin-extui
#RUN curl -fsSL https://github.com/CR6Community/Marlin/archive/extui.zip -o extui.zip && \
#	unzip extui.zip && \
#	rm extui.zip

WORKDIR /code/Marlin-extui
RUN platformio run && \
	cp /code/Marlin-extui/.pio/build/STM32F103RET6_creality/firmware*.bin /code/firmware.bin && \
	cp /code/Marlin-extui/.pio/build/STM32F103RET6_creality/firmware*.elf /code/firmware.elf

CMD du -hs /code/firmware.bin


FROM ubuntu:latest as cr6touch-devel
RUN apt update -y && \
	apt install -y zip curl && \
	apt clean

WORKDIR /code
COPY CR-6-touchscreen CR-6-touchscreen-extui
#RUN curl -fsSL https://github.com/CR6Community/CR-6-touchscreen/archive/extui.zip -o extui.zip && \
#	unzip extui.zip && \
#	rm extui.zip

WORKDIR /code/CR-6-touchscreen-extui
RUN cp -rv src/DWIN/DWIN_SET /code/DWIN_SET && \
	find /code/DWIN_SET -name "*.bmp" -exec rm -v {} \; && \
	find /code/DWIN_SET -name "13*.bin" -exec mv -v "{}" "13TouchFile.bin" \; && \
	find /code/DWIN_SET -name "14*.bin" -exec mv -v "{}" "14ShowFile.bin" \;

CMD ls -1 /code/DWIN_SET


FROM ubuntu:latest as cr6pkg
WORKDIR /installer
COPY --from=0 /code/firmware.bin  CR-6SE-firmware.bin
COPY --from=1 /code/DWIN_SET      DWIN_SET
RUN echo "`date +%Y%m%d`" > timestamp.txt

CMD du -h *
