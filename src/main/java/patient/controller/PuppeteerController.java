package patient.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import patient.service.PuppeteerService;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;

@Controller
public class PuppeteerController {

    @Autowired
    private PuppeteerService puppeteerService;

    @GetMapping("/downloadPuppeteerPdf")
    public void downloadPdf(
            HttpServletResponse response,
            @RequestParam(required = false) String title,
            @RequestParam(required = false) String name,
            @RequestParam(required = false) @DateTimeFormat(pattern="yyyy-MM-dd") Date dobFrom,
            @RequestParam(required = false) @DateTimeFormat(pattern="yyyy-MM-dd") Date dobTo,
            @RequestParam(required = false) String gender,
            @RequestParam(required = false) String prefix
    ) throws IOException {
        try {
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=Mednet_Report.pdf");

            puppeteerService.generatePdf(response.getOutputStream(), title, name, dobFrom, dobTo, gender, prefix);

        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/plain");
            response.getOutputStream().write(("Error generating PDF: " + e.getMessage()).getBytes());
        }
    }
}