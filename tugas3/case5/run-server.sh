docker rm -f mygoserver
docker run -dit \
	--name mygoserver \
	-p 8080:80 \
	mygoserver:1.0



