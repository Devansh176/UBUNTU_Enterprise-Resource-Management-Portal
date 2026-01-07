package patient.entity.titleType;

import lombok.Getter;

@Getter
public enum TitleType {
    MR("Mr."),
    MRS("Mrs."),
    MS("Ms."),
    MASTER("Master."),
    BABY_BOY("Baby boy of"),
    BABY_GIRL("Baby girl of"),
    MX("Mx."),
    DR("Dr."),
    PROF("Prof.");

    private final String displayValue;

    TitleType(String displayValue) {
        this.displayValue = displayValue;
    }

    public String getDisplayValue() {
        return displayValue;
    }
}