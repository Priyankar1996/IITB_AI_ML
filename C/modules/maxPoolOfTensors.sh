make -f Make_maxpool clean
make -f Make_maxpool compile
cd bin_maxpool
count=1
num_tests=1
while [ $count -lt $(($num_tests+1)) ]
do
    echo Test number $count
    python ../util/maxPoolInputGenerator.py >generatedinput$count.txt
    ./Test generatedinput$count.txt >&1 | tee -a shellout.txt
    count=$((count + 1))
done