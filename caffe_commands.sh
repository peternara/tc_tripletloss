# create the lmdbs
rm -r /project/focus/datasets/tc_tripletloss/small_triplet_test_lmdb
$CAFFE_ROOT/build/tools/convert_imageset --resize_height 227 --resize_width 227 / /project/focus/datasets/tc_tripletloss/small_test_triplets.txt /project/focus/datasets/tc_tripletloss/small_triplet_test_lmdb

rm -r /project/focus/datasets/tc_tripletloss/small_triplet_train_lmdb
$CAFFE_ROOT/build/tools/convert_imageset --resize_height 227 --resize_width 227 / /project/focus/datasets/tc_tripletloss/small_train_triplets.txt /project/focus/datasets/tc_tripletloss/small_triplet_train_lmdb

rm -r /project/focus/datasets/tc_tripletloss/triplet_test_lmdb
$CAFFE_ROOT/build/tools/convert_imageset --resize_height 227 --resize_width 227 / /project/focus/datasets/tc_tripletloss/test_triplets.txt /project/focus/datasets/tc_tripletloss/triplet_test_lmdb

rm -r /project/focus/datasets/tc_tripletloss/triplet_train_lmdb
$CAFFE_ROOT/build/tools/convert_imageset --resize_height 227 --resize_width 227 / /project/focus/datasets/tc_tripletloss/train_triplets.txt /project/focus/datasets/tc_tripletloss/triplet_train_lmdb

# overtrain to find good learning rate
cd /project/focus/abby/tc_tripletloss/tripletloss/

screen -S lr1
GLOG_log_dir=/project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr1/ $CAFFE_ROOT/build/tools/caffe train -solver /project/focus/abby/tc_tripletloss/models/solvers/overtrain/solver_lr1.prototxt -weights /project/focus/abby/tc_tripletloss/models/alexnet_places365.caffemodel -gpu 0
screen -S lr5
GLOG_log_dir=/project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr5/ $CAFFE_ROOT/build/tools/caffe train -solver /project/focus/abby/tc_tripletloss/models/solvers/overtrain/solver_lr5.prototxt -weights /project/focus/abby/tc_tripletloss/models/alexnet_places365.caffemodel -gpu 1
#
screen -S lr01
GLOG_log_dir=/project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr01/ $CAFFE_ROOT/build/tools/caffe train -solver /project/focus/abby/tc_tripletloss/models/solvers/overtrain/solver_lr01.prototxt -weights /project/focus/abby/tc_tripletloss/models/alexnet_places365.caffemodel -gpu 2
screen -S lr05
GLOG_log_dir=/project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr05/ $CAFFE_ROOT/build/tools/caffe train -solver /project/focus/abby/tc_tripletloss/models/solvers/overtrain/solver_lr05.prototxt -weights /project/focus/abby/tc_tripletloss/models/alexnet_places365.caffemodel -gpu 3
# if those are too high:
screen -S lr001
GLOG_log_dir=/project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr001/ $CAFFE_ROOT/build/tools/caffe train -solver /project/focus/abby/tc_tripletloss/models/solvers/overtrain/solver_lr001.prototxt -weights /project/focus/abby/tc_tripletloss/models/alexnet_places365.caffemodel -gpu 3
screen -S lr005
GLOG_log_dir=/project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr005/ $CAFFE_ROOT/build/tools/caffe train -solver /project/focus/abby/tc_tripletloss/models/solvers/overtrain/solver_lr005.prototxt -weights /project/focus/abby/tc_tripletloss/models/alexnet_places365.caffemodel -gpu 2
#
screen -S lr0001
GLOG_log_dir=/project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr0001/ $CAFFE_ROOT/build/tools/caffe train -solver /project/focus/abby/tc_tripletloss/models/solvers/overtrain/solver_lr0001.prototxt -weights /project/focus/abby/tc_tripletloss/models/alexnet_places365.caffemodel -gpu 1
screen -S lr0005
GLOG_log_dir=/project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr0005/ $CAFFE_ROOT/build/tools/caffe train -solver /project/focus/abby/tc_tripletloss/models/solvers/overtrain/solver_lr0005.prototxt -weights /project/focus/abby/tc_tripletloss/models/alexnet_places365.caffemodel -gpu 0

# once they've run long enough to over train, close the screens
screen -X -S lr1 quit
screen -X -S lr5 quit
screen -X -S lr01 quit
screen -X -S lr05 quit
screen -X -S lr001 quit
screen -X -S lr005 quit
screen -X -S lr0001 quit
screen -X -S lr0005 quit
# also make sure to either quit the jobs first or run nvidia-smi and kill any lingering tasks (the screen quit doesn't kill the training task)

# if for some reason, we stop and start over again and need to delete the logs: rm /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/*/*

# parse logs and move them so that we can grab them to have unique names
$CAFFE_ROOT/tools/extra/parse_log.py /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr1/caffe.INFO /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr1/
mv /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr1/caffe.INFO.train /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr1/lr1.train
mv /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr1/caffe.INFO.test /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr1/lr1.test

$CAFFE_ROOT/tools/extra/parse_log.py /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr5/caffe.INFO /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr5/
mv /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr5/caffe.INFO.train /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr5/lr5.train
mv /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr5/caffe.INFO.test /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr5/lr5.test

$CAFFE_ROOT/tools/extra/parse_log.py /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr01/caffe.INFO /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr01/
mv /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr01/caffe.INFO.train /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr01/lr01.train
mv /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr01/caffe.INFO.test /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr01/lr01.test

$CAFFE_ROOT/tools/extra/parse_log.py /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr05/caffe.INFO /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr05/
mv /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr05/caffe.INFO.train /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr05/lr05.train
mv /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr05/caffe.INFO.test /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr05/lr05.test

$CAFFE_ROOT/tools/extra/parse_log.py /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr001/caffe.INFO /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr001/
mv /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr001/caffe.INFO.train /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr001/lr001.train
mv /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr001/caffe.INFO.test /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr001/lr001.test

$CAFFE_ROOT/tools/extra/parse_log.py /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr005/caffe.INFO /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr005/
mv /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr005/caffe.INFO.train /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr005/lr005.train
mv /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr005/caffe.INFO.test /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr005/lr005.test

$CAFFE_ROOT/tools/extra/parse_log.py /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr0001/caffe.INFO /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr0001/
mv /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr0001/caffe.INFO.train /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr0001/lr0001.train
mv /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr0001/caffe.INFO.test /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr0001/lr0001.test

$CAFFE_ROOT/tools/extra/parse_log.py /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr0005/caffe.INFO /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr0005/
mv /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr0005/caffe.INFO.train /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr0005/lr0005.train
mv /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr0005/caffe.INFO.test /project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/lr0005/lr0005.test

# if we want to copy these to whatever local machine we're on:
mkdir ~/Desktop/overtrain
mkdir ~/Desktop/overtrain/train
mkdir ~/Desktop/overtrain/test
scp astylianou@focus.cse.wustl.edu:/project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/*/*.train ~/Desktop/overtrain/train/
scp astylianou@focus.cse.wustl.edu:/project/focus/abby/tc_tripletloss/models/logs/traffickcam/overtrain/*/*.test ~/Desktop/overtrain/test/

# once we have a good learning rate, we need to figure out a good margin
screen -S margin1
GLOG_log_dir=/project/focus/abby/tc_tripletloss/models/logs/traffickcam/margin_search/margin1/ $CAFFE_ROOT/build/tools/caffe train -solver /project/focus/abby/tc_tripletloss/models/solvers/margin_search/solver_margin1.prototxt -weights /project/focus/abby/tc_tripletloss/models/alexnet_places365.caffemodel -gpu 0
screen -S margin5
GLOG_log_dir=/project/focus/abby/tc_tripletloss/models/logs/traffickcam/margin_search/margin5/  $CAFFE_ROOT/build/tools/caffe train -solver /project/focus/abby/tc_tripletloss/models/solvers/margin_search/solver_margin5.prototxt -weights /project/focus/abby/tc_tripletloss/models/alexnet_places365.caffemodel -gpu 1
#
screen -S margin10
GLOG_log_dir=/project/focus/abby/tc_tripletloss/models/logs/traffickcam/margin_search/margin10/  $CAFFE_ROOT/build/tools/caffe train -solver /project/focus/abby/tc_tripletloss/models/solvers/margin_search/solver_margin10.prototxt -weights /project/focus/abby/tc_tripletloss/models/alexnet_places365.caffemodel -gpu 2
screen -S margin20
GLOG_log_dir=/project/focus/abby/tc_tripletloss/models/logs/traffickcam/margin_search/margin20/  $CAFFE_ROOT/build/tools/caffe train -solver /project/focus/abby/tc_tripletloss/models/solvers/margin_search/solver_margin20.prototxt -weights /project/focus/abby/tc_tripletloss/models/alexnet_places365.caffemodel -gpu 3

screen -X -S margin1 quit
screen -X -S margin5 quit
screen -X -S margin10 quit
screen -X -S margin20 quit

$CAFFE_ROOT/tools/extra/parse_log.py /project/focus/abby/tc_tripletloss/models/logs/traffickcam/margin_search/margin1/caffe.INFO /project/focus/abby/tc_tripletloss/models/logs/traffickcam/margin_search/margin1/
mv /project/focus/abby/tc_tripletloss/models/logs/traffickcam/margin_search/margin1/caffe.INFO.train /project/focus/abby/tc_tripletloss/models/logs/traffickcam/margin_search/margin1/lr1.train
mv /project/focus/abby/tc_tripletloss/models/logs/traffickcam/margin_search/margin1/caffe.INFO.test /project/focus/abby/tc_tripletloss/models/logs/traffickcam/margin_search/margin1/lr1.test

$CAFFE_ROOT/tools/extra/parse_log.py /project/focus/abby/tc_tripletloss/models/logs/traffickcam/margin_search/margin5/caffe.INFO /project/focus/abby/tc_tripletloss/models/logs/traffickcam/margin_search/margin5/
mv /project/focus/abby/tc_tripletloss/models/logs/traffickcam/margin_search/margin5/caffe.INFO.train /project/focus/abby/tc_tripletloss/models/logs/traffickcam/margin_search/margin5/lr5.train
mv /project/focus/abby/tc_tripletloss/models/logs/traffickcam/margin_search/margin5/caffe.INFO.test /project/focus/abby/tc_tripletloss/models/logs/traffickcam/margin_search/margin5/lr5.test

$CAFFE_ROOT/tools/extra/parse_log.py /project/focus/abby/tc_tripletloss/models/logs/traffickcam/margin_search/margin10/caffe.INFO /project/focus/abby/tc_tripletloss/models/logs/traffickcam/margin_search/margin10/
mv /project/focus/abby/tc_tripletloss/models/logs/traffickcam/margin_search/margin10/caffe.INFO.train /project/focus/abby/tc_tripletloss/models/logs/traffickcam/margin_search/margin10/lr01.train
mv /project/focus/abby/tc_tripletloss/models/logs/traffickcam/margin_search/margin10/caffe.INFO.test /project/focus/abby/tc_tripletloss/models/logs/traffickcam/margin_search/margin10/lr01.test

$CAFFE_ROOT/tools/extra/parse_log.py /project/focus/abby/tc_tripletloss/models/logs/traffickcam/margin_search/margin20/caffe.INFO /project/focus/abby/tc_tripletloss/models/logs/traffickcam/margin_search/margin20/
mv /project/focus/abby/tc_tripletloss/models/logs/traffickcam/margin_search/margin20/caffe.INFO.train /project/focus/abby/tc_tripletloss/models/logs/traffickcam/margin_search/margin20/lr05.train
mv /project/focus/abby/tc_tripletloss/models/logs/traffickcam/margin_search/margin20/caffe.INFO.test /project/focus/abby/tc_tripletloss/models/logs/traffickcam/margin_search/margin20/lr05.test

mkdir ~/Desktop/margin_search
mkdir ~/Desktop/margin_search/train
mkdir ~/Desktop/margin_search/test
scp astylianou@focus.cse.wustl.edu:/project/focus/abby/tc_tripletloss/models/logs/traffickcam/margin_search/*/*.train ~/Desktop/margin_search/train/
scp astylianou@focus.cse.wustl.edu:/project/focus/abby/tc_tripletloss/models/logs/traffickcam/margin_search/*/*.test ~/Desktop/margin_search/test/

# once we determine a good learning rate, update models/solver/solver.prototxt to reflect that learning rate
# train, storing log information
screen -S train
GLOG_log_dir=/project/focus/abby/tc_tripletloss/models/logs/traffickcam/lr01/ $CAFFE_ROOT/build/tools/caffe train -solver /project/focus/abby/tc_tripletloss/models/solvers/solver.prototxt -weights /project/focus/abby/tc_tripletloss/models/alexnet_places365.caffemodel -gpu 0
$CAFFE_ROOT/tools/extra/parse_log.py /project/focus/abby/tc_tripletloss/models/logs/traffickcam/lr01/caffe.INFO /project/focus/abby/tc_tripletloss/models/logs/traffickcam/lr01/
# scp -r astylianou@focus.cse.wustl.edu:/project/focus/abby/tc_tripletloss/models/logs/traffickcam/lr01 ~/Desktop
