## Dynamic Analysis

After moving the a9xk.sh script to a sandbox, the following procedure is initiated:

1. Check the script.
    `nano a9xk.sh`

    ![12](/Images/12.PNG)

2. Run the script.

    `sudo ./a9xk.sh`

    ![12a](/Images/12a.PNG)

3. Inspect the processes.

    `top`

    ![13](/Images/13.PNG)

4. Kill processes by command.

    `sudo killall stress`

    ![14](/Images/14.PNG)

5. Inspect processes were killed.

    ![15](/Images/15.PNG)

 ---

**Observations:** 

Stress is used to see how the system will perform under a lot of pressure due to different factors such as a large number of running processes.These effects are visible using the command top to display CPU usage.

---