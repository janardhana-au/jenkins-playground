#!/bin/bash
              # Extend the root partition and resize the filesystem
              # This script is suitable for most Linux AMIs
              
              ROOT_DEV=$(lsblk -o NAME,MOUNTPOINT | grep " /" | awk '{print $1}')
              
              # Find the partition number
              PART_NUM=$(lsblk -o NAME,PARTNAME | grep "^${ROOT_DEV}" | awk '{print $2}' | sed 's/[^0-9]*//g')
              
              if [ -n "$PART_NUM" ]; then
                # Check if the filesystem needs resizing
                MOUNTED_FS=$(df -h | grep "/dev/root" | awk '{print $1}')
                if [ -z "$MOUNTED_FS" ]; then
                  MOUNTED_FS=$(df -h | grep " /" | awk '{print $1}')
                fi
                
                if [ -n "$MOUNTED_FS" ]; then
                  # Extend the partition
                  growpart "/dev/${ROOT_DEV%[0-9]*}" $PART_NUM
                  
                  # Resize the filesystem
                  case $(echo $MOUNTED_FS | grep -E 'ext[2-4]|xfs') in
                    *ext*)
                      resize2fs $MOUNTED_FS
                      ;;
                    *xfs*)
                      xfs_growfs $MOUNTED_FS
                      ;;
                    *)
                      echo "Filesystem type not supported for automatic resize."
                      ;;
                  esac
                fi
              fi
              EOF

  tags ={
    Name = var.jenkins_instances[count.index]
  }
}