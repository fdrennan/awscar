# Get new instructions
cd /home/ubuntu 
/home/ubuntu/.local/bin/aws s3 cp s3://awscar/instructions.txt instructions.txt

modelname=$(cat instructions.txt | sed 's/[][]//g' | jq -r '.model_name' | cat)
/home/ubuntu/.local/bin/aws s3 cp 's3://awscar/'$modelname'.zip' $modelname'/'$modelname'.zip'
cd $modelname
unzip $modelname'.zip'
/usr/bin/Rscript /home/ubuntu/reboot.R
/home/ubuntu/.local/bin/aws s3 cp $modelname'/'$modelname'_model.rda' 's3://awscar/'$modelname'_model.rda'

