make clean
make compile
cd bin
count=1

while [ $count -lt 51 ]
do
    echo Test number $count
    python ../util/Test_inputs/input_generator.py >generatedinput$count.txt
    ./Test generatedinput$count.txt >&1 | tee -a shellout.txt
    count=$((count + 1))
done