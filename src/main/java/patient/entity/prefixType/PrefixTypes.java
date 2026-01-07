package patient.entity.prefixType;

import lombok.Getter;

@Getter
public enum PrefixTypes {
    SO("S/O"),
    HO("H/O"),
    FO("F/O"),
    DO("D/O"),
    WO("W/O"),
    MO("M/O");

    private final String displayValue;

    PrefixTypes(String displayValue) {
        this.displayValue = displayValue;
    }

    public String getDisplayValue() {
        return displayValue;
    }
}