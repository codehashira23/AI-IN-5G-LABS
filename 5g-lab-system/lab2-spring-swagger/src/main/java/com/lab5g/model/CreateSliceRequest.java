package com.lab5g.model;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record CreateSliceRequest(
        @NotBlank @Size(max = 64) String name,
        @NotBlank @Size(max = 32) String sst,
        String sd
) {
}
