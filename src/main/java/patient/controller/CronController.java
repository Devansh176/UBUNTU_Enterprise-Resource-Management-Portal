package patient.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import patient.service.DynamicCronService;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/cron")
public class CronController {

    @Autowired
    private DynamicCronService schedulerService;

    @PostMapping("/update")
    public String updateCron(@RequestParam("expression") String expression) {
        return schedulerService.updateCron(expression);
    }

    @GetMapping("/current")
    public String getCurrentCron() {
        return schedulerService.getCurrentCron();
    }

    @GetMapping("/logs")
    public List<Map<String, String>> getLogs() {
        return schedulerService.getRecentLogs().stream()
                .map(msg -> Collections.singletonMap("logEntry", msg))
                .collect(Collectors.toList());
    }
}