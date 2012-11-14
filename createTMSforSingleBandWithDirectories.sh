#!/bin/bash
#The DuKode Studio 2012
#author ilias koen
#desc: generate single band tms files. 
#ex .createTMSforSingleBands <directory of band tiffs> 
# place tif files on their directories and parce the directories as arguments (where test a directory with the unzipped tif bands)
#ex sh createTMSforSingleBands.sh test test1 


# x to the power of y function  
pow() {
    local x y res i
    x=$1
    y=$2
    res=1
    i=1
    while [ $i -le $y ]; do
        res=$(( res * x ))
        i=$(( i + 1 ))
    done
    echo $res
}

#create tms for the specific band name provided ex. createTMSforBandWithFileName xxxxx_b10.tif
createTMSforBandWithFileName(){
	local BAND
	echo $1
	BAND=$1
	# CHECK IF FILE IS ZIPPED AND IF UNZIP 
	
	if [[ $BAND == *.gz* ]]; then
		echo "/n################################################"		
		echo "# processing $BAND"		
		echo "##################################################/n"		
		
		echo "unzipping file:\n $BAND"
		gunzip -d -f $BAND
		# echo "done"
		
		#$(echo $BAND10|sed 's/.gz/ /g')
		# BANDZIP=$(echo $BAND )
		BAND=$(echo $BAND|sed 's/.gz//	')
		# echo "file is unzipped:\n $BAND"
	fi
	# echo $BAND
	if [ -f $BAND ]; then 
		echo "/n################################################"		
		echo "# processing $BAND"		
		echo "##################################################/n"		
		
		newname=`echo "$BAND"| sed 's/\.TIF$//' | sed 's/\.tif$//'`
		# echo "newname = $newname" 
		
		BANDFILE="$newname.alpha.TIF"
		BANDDIR="$newname"
	
		# warp with alpha
		gdalwarp -dstalpha -srcnodata "0 0 0" -dstnodata "0 0 0" -co "TILED=YES" "$BAND" "$BANDFILE"
		# create TMS layer 
		python /Library/Frameworks/GDAL.framework/Versions/1.9/Programs/gdal2tiles.py --srcnodata="0,0,0" -z "$minZoom-$maxZoom" "$BANDFILE" "$BANDDIR"
		#fi 
		# exit 0
		
		# rm "$BAND"
	    rm  "$BANDFILE"
		#rezip file when done to decrease repository size
		gzip -vf -9 "$BAND" "$BAND.gz"
	fi
}

#################################################################################

#################################################################################

#################################################################################
args=("$@")
NUM1=$#
NUM2=2

maxZoom=18
minZoom=15

n=-1
 for i in ${args[@]}; do
 	if [ -d $i ]; then 
 	 	echo "["."$(( n += 1 ))"."]" " $i"		
 	fi
 done
 DIRS="$n"
 # echo $DIRS

 # echo "hello" 
  ######################################
  for d in ${args[@]}; do
  	echo "$d in arg"
  	if [ -d $d ]; then
  		# echo "$d in directory" 
		echo "/n################################################"		
		echo "#"
		echo "# processing $d"		
		echo "#"
		echo "#################################################\n"		

  		FILES=$d/*
  		TILEFILESARRAY=(`echo $FILES`)
  		# echo "*******\n$FILES\n"
  		# RESULT="found"
  		for i in ${TILEFILESARRAY[@]}; do
  			if [[ "$i" == *B10* ]] || [[  "$i" == *10.tif* ]] ||  [[ "$i" == *01.tif* ]] || [[ "$i" == *nn1.tif* ]] || [[ "$i" == *01.gz* ]]; then
  				createTMSforBandWithFileName $i 
  			
  			# B20
  			elif [[ "$i" == *B20* ]] || [[  "$i" == *20.tif* ]] ||  [[ "$i" == *02.tif* ]] || [[ "$i" == *nn2.tif* ]] || [[ "$i" == *02.gz* ]]; then
  				createTMSforBandWithFileName $i 
  			
  			#B30
  			elif [[ "$i" == *B30* ]] || [[  "$i" == *30.tif* ]] ||  [[ "$i" == *03.tif* ]] || [[ "$i" == *nn3.tif* ]] || [[ "$i" == *03.gz* ]]; then
  				createTMSforBandWithFileName $i 
  			
  			#B40
  			elif [[ "$i" == *B40* ]] || [[  "$i" == *40.tif* ]] ||  [[ "$i" == *04.tif* ]] || [[ "$i" == *nn4.tif* ]] || [[ "$i" == *04.gz* ]]; then
  				createTMSforBandWithFileName $i 
  		
  			
  			#B50
  			elif [[ "$i" == *B50* ]] || [[  "$i" == *50.tif* ]] ||  [[ "$i" == *05.tif* ]] || [[ "$i" == *nn5.tif* ]] || [[ "$i" == *05.gz* ]]; then
  				createTMSforBandWithFileName $i 
  			
  			#B60
  			elif [[ "$i" == *B60* ]] || [[  "$i" == *60.tif* ]] ||  [[ "$i" == *06.tif* ]] || [[ "$i" == *nn6.gz* ]] || [[ "$i" == *06.gz* ]]; then
  		  				createTMSforBandWithFileName $i 
  		  			
  			
  			# #B61
  			# 		elif [ "$i" == *B61* ] || [ "$i" == *61.tif* ]; then
  			# 			createTMSforBandWithFileName $i 
  			# 		
  			# 		
  			# 		#B62
  			# 		elif [ "$i" == *B62* ] || [ "$i" == *62.tif* ]; then
  			# 			createTMSforBandWithFileName $i 
  			# 		
  			
  			#B10
  			elif [[ "$i" == *B70* ]] || [[  "$i" == *70.tif* ]] ||  [[ "$i" == *07.tif* ]] || [[ "$i" == *nn7.tif* ]] || [[ "$i" == *07.gz* ]]; then
  				createTMSforBandWithFileName $i
  			#B80
  			# elif [[ "$i" == *B80* ]] || [[  "$i" == *80.tif* ]] ||  [[ "$i" == *08.tif* ]] || [[ "$i" == *nn8.gz* ]] || [[ "$i" == *08.gz* ]]; then
  			#    				createTMSforBandWithFileName $i 
  			#    					
  			fi
  		done
  	fi
done

  
  echo "#### "
  echo "done"
  exit 0 
