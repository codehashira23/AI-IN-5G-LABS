package com.lab5g.web;

import com.lab5g.model.CreateSliceRequest;
import com.lab5g.model.NetworkSlice;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;

@RestController
@RequestMapping("/api/slices")
@Tag(name = "Network Slices", description = "Minimal CRUD for lab demonstration")
public class SliceController {

    private final Map<Long, NetworkSlice> store = new ConcurrentHashMap<>();
    private final AtomicLong seq = new AtomicLong(1);

    @GetMapping("/{id}")
    @Operation(summary = "Get slice by id")
    public ResponseEntity<NetworkSlice> get(@PathVariable long id) {
        var v = store.get(id);
        return v == null ? ResponseEntity.notFound().build() : ResponseEntity.ok(v);
    }

    @PostMapping
    @Operation(summary = "Create slice")
    public ResponseEntity<NetworkSlice> create(@Valid @RequestBody CreateSliceRequest body) {
        long id = seq.getAndIncrement();
        var saved = new NetworkSlice(id, body.name(), body.sst(), body.sd());
        store.put(id, saved);
        return ResponseEntity.status(201).body(saved);
    }
}
