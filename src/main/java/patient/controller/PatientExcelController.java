package patient.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.context.annotation.ScopedProxyMode;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import patient.service.PatientExcelService;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@Controller
public class PatientExcelController {

    @Autowired
    private PatientExcelService patientExcelService;

    @PostMapping("/uploadPatientExcel")
    public void uploadExcel(@RequestParam("excelFile") MultipartFile file, HttpServletResponse response) throws IOException {
        response.setContentType("text/html");

        if (file.isEmpty()) {
            response.getWriter().write("{success: false, msg: 'File is empty'}");
            return;
        }
        try {
            // Controller converts MultipartFile -> InputStream
            patientExcelService.processExcelUpload(file.getInputStream());
            response.getWriter().write("{success: true}");
        } catch (Exception e) {
            response.getWriter().write("{success: false, msg: '" + e.getMessage().replace("'", "") + "'}");
        }
    }


    @GetMapping("/downloadPatientExcel")
    public void downloadExcel(HttpServletResponse response) throws IOException {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=Patient_data.xlsx");

        // Controller converts HttpServletResponse -> OutputStream
        patientExcelService.generateExcelReport(response.getOutputStream());
    }
}