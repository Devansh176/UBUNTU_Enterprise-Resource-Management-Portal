package patient.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import patient.entity.Patient;

import java.io.*;
import java.util.Date;
import java.util.List;

@Service
public class PuppeteerService {

    @Autowired
    private PatientService patientService;

    @Value("${puppeteer.script.dir}")
    private String scriptDir;

    @Value("${puppeteer.node.path}")
    private String nodeExe;

    @Value("${puppeteer.script.name}")
    private String scriptName;

    @Value("${puppeteer.output.file}")
    private String outputPdfName;

    @Value("${puppeteer.html.file}")
    private String inputHtmlName;

    public void generatePdf(OutputStream outputStream, String title, String name, Date dobFrom, Date dobTo, String gender, String prefix) throws IOException {
        createDataHtmlFile(title, name, dobFrom, dobTo, gender, prefix);
        runPuppeteerScript();

        File pdfFile = new File(scriptDir, outputPdfName);
        if (!pdfFile.exists()) {
            throw new RuntimeException("PDF file was not generated at: " + pdfFile.getAbsolutePath());
        }

        try (FileInputStream in = new FileInputStream(pdfFile)) {
            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
            }
        }
        outputStream.flush();
    }

    private void createDataHtmlFile(String title, String name, Date dobFrom, Date dobTo, String gender, String prefixName) throws IOException {
        List<Patient> list = patientService.searchWithFilters(title, name, dobFrom, dobTo, gender, prefixName);

        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");

        StringBuilder html = new StringBuilder();
        html.append("<html><head><style>")
                .append("body { font-family: Arial, sans-serif; }")
                .append("table { width: 100%; border-collapse: collapse; margin-top: 20px; }")
                .append("th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }")
                .append("th { background-color: #4CAF50; color: white; }")
                .append("tr:nth-child(even) { background-color: #f2f2f2; }")
                .append(".no-data { color: red; font-weight: bold; margin-top: 20px; }")
                .append("</style></head><body>");

        html.append("<h1>Mednet Report</h1>");

        // Handle Empty Data Case
        if (list.isEmpty()) {
            html.append("<p class='no-data'>No records found matching your criteria.</p>");
        } else {
            html.append("<table>");
            html.append("<thead><tr>")
                    .append("<th>ID</th>")
                    .append("<th>Title</th>")
                    .append("<th>Name</th>")
                    .append("<th>DOB</th>")
                    .append("<th>Gender</th>")
                    .append("<th>Patient</th>")
                    .append("</tr></thead>");
            html.append("<tbody>");

            for (Patient p : list) {
                html.append("<tr>");
                html.append("<td>").append(p.getId()).append("</td>");
                html.append("<td>").append(p.getTitle() != null ? p.getTitle() : "").append("</td>");
                html.append("<td>").append(p.getName() != null ? p.getName() : "").append("</td>");

                String dateStr = (p.getDob() != null) ? sdf.format(p.getDob()) : "";
                html.append("<td>").append(dateStr).append("</td>");

                html.append("<td>").append(p.getGender() != null ? p.getGender() : "").append("</td>");
                html.append("<td>").append(p.getPrefix() != null ? p.getPrefix() : "").append("</td>");
                html.append("</tr>");
            }
            html.append("</tbody></table>");
        }

        html.append("</body></html>");

        File htmlFile = new File(scriptDir, inputHtmlName);
        try (PrintWriter writer = new PrintWriter(htmlFile)) {
            writer.write(html.toString());
        }
    }


    private void runPuppeteerScript() throws IOException {
        try {
            File htmlFile = new File(scriptDir, inputHtmlName);
            File pdfFile = new File(scriptDir, outputPdfName);

            // Structure: [Node.exe] [Script.js] [InputHTMLPath] [OutputPDFPath]
            ProcessBuilder builder = new ProcessBuilder(
                    nodeExe,
                    scriptName,
                    htmlFile.getAbsolutePath(),
                    pdfFile.getAbsolutePath()
            );

            builder.directory(new File(scriptDir));

            Process process = builder.start();
            int exitCode = process.waitFor();

            if (exitCode != 0) {
                // Read both Error stream and Standard Output stream for debugging
                String errorMsg = readInputStream(process.getErrorStream());
                String logMsg = readInputStream(process.getInputStream());

                throw new RuntimeException("Node script failed.\nExit Code: " + exitCode +
                        "\nError: " + errorMsg +
                        "\nLog: " + logMsg);
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new IOException("Process interrupted", e);
        }
    }


    private String readInputStream(InputStream inputStream) throws IOException {
        ByteArrayOutputStream buffer = new ByteArrayOutputStream();
        int nRead;
        byte[] data = new byte[1024];
        // Read the stream in chunks
        while ((nRead = inputStream.read(data, 0, data.length)) != -1) {
            buffer.write(data, 0, nRead);
        }
        buffer.flush();
        // Convert bytes to String
        return new String(buffer.toByteArray(), "UTF-8");
    }
}