build:
	docker build --force-rm=true -t bcl-group/ubuntu-anaconda3-opencv3 .

run:
	docker run -it --rm -e XMODIFIERS -v /tmp/.X11-unix:/tmp/.X11-unix \
		-v `pwd`:/home/pochi/ jnishii/ubuntu-anaconda3-opencv3

ps:
	docker ps -a

clean:
	rm *~
