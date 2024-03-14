package my.uum;

import java.util.*;

public class RoundRobinScheduler {

    // Initialization of variables
    private List<RoundRobinCalculator.ProcessInfo> processesInfo;
    private int timeQuantum;
    private List<String> responseString;

    /**
     * Constructor of the class RoundRobinScheduler
     */
    public RoundRobinScheduler() {
        this.processesInfo = new ArrayList<>();
        this.responseString = new ArrayList<>();
    }

    /**
     * Method 1: addProcess to add all the processes input by user into the list
     * @param process input by users, minimum four number of processes per input
     */
    public void addProcess(RoundRobinCalculator.ProcessInfo process) {
        processesInfo.add(process);
    }

    /**
     * Method 2: calculate time quantum for the scheduling algorithm using median of the burst time
     */
    public void calculateTimeQuantum() {
        List<Integer> burstTimes = new ArrayList<>();
        for (RoundRobinCalculator.ProcessInfo process : processesInfo) {
            burstTimes.add(process.bt);
        }

        Collections.sort(burstTimes);

        int n = burstTimes.size();
        if (n % 2 == 0) {
            timeQuantum = (burstTimes.get(n / 2 - 1) + burstTimes.get(n / 2)) / 2;
        } else {
            timeQuantum = burstTimes.get(n / 2);
        }
    }

    /**
     * Method 3: run method to carry out the scheduling, process data and return output
     */
    public void run() {
        int totalProcesses = processesInfo.size();
        int[] remainingTime = new int[totalProcesses];
        int[] arrivalTime = new int[totalProcesses];
        String[] processId = new String[totalProcesses];

        boolean[] hasStartedExecution = new boolean[totalProcesses];

        for (int i = 0; i < totalProcesses; i++) {
            remainingTime[i] = processesInfo.get(i).bt;
            arrivalTime[i] = processesInfo.get(i).at;
            processId[i] = processesInfo.get(i).job;
        }

        int currentTime = 0;

        while (true) {
            boolean done = true;

            for (int i = 0; i < totalProcesses; i++) {
                if (remainingTime[i] > 0) {
                    done = false;

                    if (!hasStartedExecution[i]) {
                        int response = Math.max(0, currentTime - arrivalTime[i]);
                        String responseString = "Process " + processId[i] + ": " + response;
                        this.responseString.add(responseString);
                        hasStartedExecution[i] = true;
                    }

                    if (remainingTime[i] > timeQuantum) {
                        currentTime += timeQuantum;
                        remainingTime[i] -= timeQuantum;
                    } else {
                        currentTime += remainingTime[i];
                        remainingTime[i] = 0;
                    }
                }
            }

            if (done) {
                break;
            }
        }
    }

    /**
     * Method to get response string
     * @return finalResponse
     */
    public String getResponseString() {
        StringBuilder response = new StringBuilder();
        for (String str : responseString) {
            response.append(str).append("\n");
        }

        return response.toString();
    }

       /**
     * Method 4: getters for average results
     * @return average turnaround time
     */
    public double getAverageTurnaroundTime() {
        return calculateAverage(turnaroundTimes);
    }

    /**
     * Method 5: getters for average results
     * @return average response time
     */
    public double getAverageResponseTime() {
        return calculateAverage(responseTimes);
    }

    /**
     * Method 6: getters for average results
     * @return average waiting time
     */
    public double getAverageWaitTime() {
        return calculateAverage(waitingTimes);
    }

    /**
     * Method 7: Calculate for average results
     * @param values waiting time, response time and turnaround time
     * @return average values
     */
    public double calculateAverage(List<Integer> values) {
        int sum = 0;
        for (int value : values) {
            sum += value;
        }
        return (double) sum / values.size();
    }
}
