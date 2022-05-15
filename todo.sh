#! /bin/bash

case $1 in
    add)
        while [ $# -gt 0 ]
        do
            case $1 in
                -t)
                    taskDescription=$2
                    ;;
                --title)
                    taskDescription=$2
                    ;;
                -p)
                    taskPriority=$2
                    ;;
                --priority)
                    taskPriority=$2
                    ;;
            esac
            shift
        done
        
        if [ -z "$taskDescription" ]
        then
            echo 'Option -t|--title Needs a Parameter'
        else
            if [ -z $taskPriority ]
            then
                taskPriority=L
            fi
            
            if [ $taskPriority == L ] || [ $taskPriority == M ] || [ $taskPriority == H ]
            then
                echo "0,$taskPriority,\"$taskDescription\"" >> tasks.csv
            else
                echo 'Option -p|--priority Only Accept L|M|H'
            fi
        fi
        ;;
    clear)
        cat /dev/null > tasks.csv
        ;;
    list)
        awk 'BEGIN{FS=","; num=1} {printf "%s | %s | %s | %s\n", num, $1, $2, $3; num++}' tasks.csv
        ;;
    find)
        grep -in $2 tasks.csv | awk 'BEGIN{FS=":"; OFS=","} {print $1, $2}' | awk 'BEGIN{FS=","; OFS=" | "} {print $1, $2, $3, $4}'
        ;;
    done)
        targetRow=$(tail +$2 tasks.csv| head -n 1)
        updatedRow=$(tail +$2 tasks.csv| head -n 1 | awk 'BEGIN{FS=","} {printf "1,%s,%s", $2, $3}')
        lines=$(wc -l tasks.csv | awk 'BEGIN{FS=" "} {print $1}')
        for ((i = 1; i <= $lines; i++))
        do
            if [ $2 == $i ]
            then
                echo $updatedRow >> temp.csv
            else
                echo $(tail +$i tasks.csv| head -n 1) >> temp.csv
            fi
        done
        rm tasks.csv
        mv temp.csv tasks.csv
        ;;
    *)
        echo Command Not Supported!
        ;;
esac

