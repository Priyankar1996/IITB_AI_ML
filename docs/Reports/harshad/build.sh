if test "$#" -ne 1; then
    echo "Illegal number of parameters"
    echo "Usage : ./build.sh [dir_name]"
    echo "        dir_name = source dir name."
    exit
fi

cd ./$1
./run.sh
mv main.pdf ../thesis.pdf
rm main.lof main.log main.lot main.out main.toc main.bbl main.blg
cd ..
