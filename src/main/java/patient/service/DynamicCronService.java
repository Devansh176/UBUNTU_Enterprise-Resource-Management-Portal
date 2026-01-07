package patient.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.scheduling.concurrent.ThreadPoolTaskScheduler;
import org.springframework.scheduling.support.CronTrigger;
import org.springframework.stereotype.Service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.concurrent.ScheduledFuture;

@Service
public class DynamicCronService implements ApplicationListener<ContextRefreshedEvent> {

    @Autowired
    private ThreadPoolTaskScheduler taskScheduler;

    private volatile ScheduledFuture<?> scheduledTask;
    private String currentCronExpression = "0 * * * * *"; // Default: Every minute

    private final List<String> executionLogs = Collections.synchronizedList(new ArrayList<>());
    private final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    @Override
    public void onApplicationEvent(ContextRefreshedEvent event) {
        if (scheduledTask == null) {
            addLog("System Started. Initializing Cron: " + currentCronExpression);
            startScheduler(currentCronExpression);
        }
    }

    private void executeTask() {
        addLog("CRON JOB EXECUTED SUCCESSFULLY");
        System.out.println("CRON EXECUTED AT: " + new Date());
    }


    public String updateCron(String newCronExpression) {
        if (scheduledTask != null) {
            scheduledTask.cancel(false);
        }

        try {
            startScheduler(newCronExpression);
            this.currentCronExpression = newCronExpression;
            addLog("Configuration Changed: Cron updated to " + newCronExpression);
            return "Success: Cron updated to " + newCronExpression;
        } catch (IllegalArgumentException e) {
            addLog("Error: Failed attempt to set invalid cron " + newCronExpression);
            startScheduler(currentCronExpression); // Revert
            return "Error: Invalid Cron Expression";
        }
    }



    private void startScheduler(String cron) {
        scheduledTask = taskScheduler.schedule(
                this::executeTask,
                new CronTrigger(cron)
        );
    }

    public String getCurrentCron() {
        return currentCronExpression;
    }

    public List<String> getRecentLogs() {
        synchronized (executionLogs) {
            return new ArrayList<>(executionLogs);
        }
    }

    private void addLog(String message) {
        String timestamp = dateFormat.format(new Date());
        String logEntry = "[" + timestamp + "] " + message;

        executionLogs.add(0, logEntry);

        // Keep only last 50 logs to save memory
        if (executionLogs.size() > 50) {
            executionLogs.remove(executionLogs.size() - 1);
        }
    }
}