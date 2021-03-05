PYTHON2=/usr/bin/python2
if [ ! -f $PYTHON2 ]; then
	echo "$PYTHON2 not found"
	cmd=sudo apt install python2
	echo $cmd
	$cmd
fi
GDK_LOADERS=gdk-pixbuf-query-loaders
if [ ! -f /usr/local/bin/$GDK_LOADERS ]; then
	cmd="sudo ln -s /usr/lib/*/gdk-pixbuf-2.0/$GDK_LOADERS /usr/local/bin/$GDK_LOADERS"
	echo $cmd
	$cmd
fi
make PYTHON2=$PYTHON2

