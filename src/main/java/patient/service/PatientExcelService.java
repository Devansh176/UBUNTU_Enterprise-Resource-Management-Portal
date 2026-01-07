package patient.service;

import org.springframework.transaction.annotation.Transactional;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.context.annotation.ScopedProxyMode;
import org.springframework.stereotype.Service;
import patient.entity.Patient;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@Service
@Transactional
public class PatientExcelService {

    @Autowired
    private PatientService patientService;


    public void processExcelUpload(InputStream inputStream) throws IOException {
        try (Workbook workbook = new XSSFWorkbook(inputStream)) {
            Sheet sheet = workbook.getSheetAt(0);

            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null) continue;

                String name = getCellValue(row.getCell(0));
                String dobString = getCellValue(row.getCell(1));
                String title = getCellValue(row.getCell(2));
                String gender = getCellValue(row.getCell(3));
                String prefixName = getCellValue(row.getCell(4));

                Date dob = null;
                try {
                    if (!dobString.isEmpty()) {
                        dob = dateFormat.parse(dobString);
                    }
                } catch (Exception e) {
                    System.out.println("Invalid Date format for row " + i + ": " + dobString);
                }

                if (!title.isEmpty() && !gender.isEmpty() && !prefixName.isEmpty()) {
                    patientService.createPrefix(title, name, dob, gender, prefixName);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error processing Excel file: " + e.getMessage());
        }
    }


    public void generateExcelReport(OutputStream outputStream) throws IOException {
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Patient Data");

            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

            Row header = sheet.createRow(0);
            header.createCell(0).setCellValue("ID");
            header.createCell(1).setCellValue("Name");
            header.createCell(2).setCellValue("DOB");
            header.createCell(3).setCellValue("Title");
            header.createCell(4).setCellValue("Gender");
            header.createCell(5).setCellValue("Prefix");

            List<Patient> list = patientService.getAllPatients();
            int rowIdx = 1;
            for (var p : list) {
                Row row = sheet.createRow(rowIdx++);

                row.createCell(0).setCellValue(p.getId());
                row.createCell(1).setCellValue(p.getName() != null ? p.getName() : "");
                String dobStr = (p.getDob() != null) ? dateFormat.format(p.getDob()) : "";
                row.createCell(2).setCellValue(dobStr);

                row.createCell(3).setCellValue(p.getTitle() != null ? p.getTitle().name() : "");
                row.createCell(4).setCellValue(p.getGender() != null ? p.getGender().name() : "");
                row.createCell(5).setCellValue(p.getPrefix() != null ? p.getPrefix().name() : "");
            }

            workbook.write(outputStream);
        }
    }

    private String getCellValue(Cell cell) {
        if (cell == null) return "";
        // Basic check to handle Excel treating numbers/dates oddly
        if (cell.getCellType() == CellType.NUMERIC) {
            if (DateUtil.isCellDateFormatted(cell)) {
                return new SimpleDateFormat("yyyy-MM-dd").format(cell.getDateCellValue());
            }
            return String.valueOf((int)cell.getNumericCellValue());
        }
        return cell.toString().trim();
    }
}