package my.uum;

public class Main {
    public static void main(String[] args) {
        RoundRobinScheduler scheduler = new RoundRobinScheduler();

        // Adding processes A, B, C, D with their respective burst times and arrival times
        RoundRobinCalculator.ProcessInfo processA = new RoundRobinCalculator.ProcessInfo("A", 3, 4);
        RoundRobinCalculator.ProcessInfo processB = new RoundRobinCalculator.ProcessInfo("B", 6, 4);
        RoundRobinCalculator.ProcessInfo processC = new RoundRobinCalculator.ProcessInfo("C", 6, 5);
        RoundRobinCalculator.ProcessInfo processD = new RoundRobinCalculator.ProcessInfo("D", 10, 8);

        scheduler.addProcess(processA);
        scheduler.addProcess(processB);
        scheduler.addProcess(processC);
        scheduler.addProcess(processD);

        // Calculate time quantum based on the processes added
        scheduler.calculateTimeQuantum();

        // Run the scheduling algorithm
        scheduler.run();

        // Get the response string from the scheduler
        String responseString = scheduler.getResponseString();

        // Display the response string
        System.out.println(responseString);
    }
}
