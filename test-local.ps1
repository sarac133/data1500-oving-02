# ============================================================
# Test script for DATA1500 Øving 2 - Webapplikasjoner
# Kompatibel med: Windows PowerShell
# 
# Bruk: .\test-local.ps1
# ============================================================

# Tellere
$passed = 0
$failed = 0

# Test data directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$TestDataDir = Join-Path $ScriptDir "testdata"

# Funksjon for å kjøre test
function Run-Test {
    param(
        [string]$testName,
        [scriptblock]$command
    )
    
    Write-Host "  Testing: $testName... " -NoNewline
    
    try {
        $result = & $command
        if ($result) {
            Write-Host "✅" -ForegroundColor Green
            $script:passed++
        } else {
            Write-Host "❌" -ForegroundColor Red
            $script:failed++
        }
    } catch {
        Write-Host "❌" -ForegroundColor Red
        $script:failed++
    }
}

Write-Host "================================================"
Write-Host "  DATA1500 Øving 2 - Webapplikasjoner"
Write-Host "  Local Test Suite (Windows)"
Write-Host "================================================"
Write-Host ""

# ============================================================
# OPPGAVE 1: Enkel READ-API
# ============================================================
Write-Host ""
Write-Host "--- Oppgave 1: Enkel READ-API ---"
if (Test-Path "oppgave1") {
    Push-Location oppgave1
    
    # Compile
    Write-Host -NoNewline "Compiling StudentAPI.java... "
    $compileResult = javac StudentAPI.java 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅" -ForegroundColor Green
        
        # Start server in background
        $process = Start-Process -FilePath "java" -ArgumentList "StudentAPI", "9001", "$testdataDir\data\studenter.csv" `
            -NoNewWindow -PassThru -RedirectStandardOutput $null -RedirectStandardError $null
        Start-Sleep -Seconds 1
        
        # Test 1: Hent alle studenter
        Run-Test "GET /api/students" {
            $response = Invoke-WebRequest -Uri "http://localhost:9001/api/students" -ErrorAction SilentlyContinue
            $response.Content -like "*Mickey*"
        }
        
        # Test 2: Hent spesifikk student
        Run-Test "GET /api/students/101" {
            $response = Invoke-WebRequest -Uri "http://localhost:9001/api/students/101" -ErrorAction SilentlyContinue
            $response.Content -like "*`"id`":101*"
        }
        
        # Test 3: Health check
        Run-Test "GET /health" {
            $response = Invoke-WebRequest -Uri "http://localhost:9001/health" -ErrorAction SilentlyContinue
            $response.Content -like "*OK*"
        }
        
        # Kill server
        Stop-Process -Id $process.Id -Force -ErrorAction SilentlyContinue
        
    } else {
        Write-Host "❌ Compilation failed" -ForegroundColor Red
        $failed += 3
    }
    
    Pop-Location
} else {
    Write-Host "⚠️  Oppgave 1 directory not found" -ForegroundColor Yellow
}

# ============================================================
# OPPGAVE 2: API med Søk
# ============================================================
Write-Host ""
Write-Host "--- Oppgave 2: API med Søk og SQL Injection-illustrasjon ---"
if (Test-Path "oppgave2") {
    Push-Location oppgave2
    
    # Compile
    Write-Host -NoNewline "Compiling UserSearchAPI.java... "
    $compileResult = javac UserSearchAPI.java 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅" -ForegroundColor Green
        
        # Start server in background
        $process = Start-Process -FilePath "java" -ArgumentList "UserSearchAPI", "9002", "$testdataDir\data\brukere.csv" `
            -NoNewWindow -PassThru -RedirectStandardOutput $null -RedirectStandardError $null
        Start-Sleep -Seconds 1
        
        # Test 1: Hent alle brukere
        Run-Test "GET /api/users" {
            $response = Invoke-WebRequest -Uri "http://localhost:9002/api/users" -ErrorAction SilentlyContinue
            $response.Content -like "*bruker1@epost.no*"
        }
        
        # Test 2: Søk etter bruker
        Run-Test "GET /api/search?email=bruker1@epost.no" {
            $response = Invoke-WebRequest -Uri "http://localhost:9002/api/search?email=bruker1@epost.no" -ErrorAction SilentlyContinue
            $response.Content -like "*bruker1@epost.no*"
        }
        
        # Kill server
        Stop-Process -Id $process.Id -Force -ErrorAction SilentlyContinue
        
    } else {
        Write-Host "❌ Compilation failed" -ForegroundColor Red
        $failed += 2
    }
    
    Pop-Location
} else {
    Write-Host "⚠️  Oppgave 2 directory not found" -ForegroundColor Yellow
}

# ============================================================
# OPPGAVE 3: CRUD-API med UPDATE
# ============================================================
Write-Host ""
Write-Host "--- Oppgave 3: CRUD-API med UPDATE ---"
if (Test-Path "oppgave3") {
    Push-Location oppgave3
    
    # Lag kopi av test-data
    Copy-Item "$testdataDir\data\studenter.csv" "test_studenter.csv" -Force
    
    # Compile
    Write-Host -NoNewline "Compiling StudentCRUDAPI.java... "
    $compileResult = javac StudentCRUDAPI.java 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅" -ForegroundColor Green
        
        # Start server in background
        $process = Start-Process -FilePath "java" -ArgumentList "StudentCRUDAPI", "9003", "test_studenter.csv" `
            -NoNewWindow -PassThru -RedirectStandardOutput $null -RedirectStandardError $null
        Start-Sleep -Seconds 1
        
        # Test 1: GET student
        Run-Test "GET /api/students/101" {
            $response = Invoke-WebRequest -Uri "http://localhost:9003/api/students/101" -ErrorAction SilentlyContinue
            $response.Content -like "*`"id`":101*"
        }
        
        # Test 2: PUT (update) student
        Run-Test "PUT /api/students/101" {
            $body = @{name="Mickey Mouse"; program="CS"} | ConvertTo-Json
            $response = Invoke-WebRequest -Uri "http://localhost:9003/api/students/101" -Method Put `
                -ContentType "application/json" -Body $body -ErrorAction SilentlyContinue
            $response.Content -like "*Mickey Mouse*"
        }
        
        # Kill server
        Stop-Process -Id $process.Id -Force -ErrorAction SilentlyContinue
        
    } else {
        Write-Host "❌ Compilation failed" -ForegroundColor Red
        $failed += 2
    }
    
    # Cleanup
    Remove-Item "test_studenter.csv" -Force -ErrorAction SilentlyContinue
    
    Pop-Location
} else {
    Write-Host "⚠️  Oppgave 3 directory not found" -ForegroundColor Yellow
}

# ============================================================
# OPPGAVE 4: CRUD-API med DELETE og Analytics
# ============================================================
Write-Host ""
Write-Host "--- Oppgave 4: CRUD-API med DELETE og Analytics ---"
if (Test-Path "oppgave4") {
    Push-Location oppgave4
    
    # Lag kopier av test-data
    Copy-Item "$testdataDir\data\studenter.csv" "test_studenter.csv" -Force
    Copy-Item "$testdataDir\data\quiz-res.csv" "test_quiz_res.csv" -Force
    
    # Compile
    Write-Host -NoNewline "Compiling QuizAnalyticsAPI.java... "
    $compileResult = javac QuizAnalyticsAPI.java 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅" -ForegroundColor Green
        
        # Start server in background
        $process = Start-Process -FilePath "java" -ArgumentList "QuizAnalyticsAPI", "9004", "test_studenter.csv", "test_quiz_res.csv" `
            -NoNewWindow -PassThru -RedirectStandardOutput $null -RedirectStandardError $null
        Start-Sleep -Seconds 1
        
        # Test 1: GET quiz stats
        Run-Test "GET /api/analytics/quiz-stats" {
            $response = Invoke-WebRequest -Uri "http://localhost:9004/api/analytics/quiz-stats" -ErrorAction SilentlyContinue
            $response.Content -like "*average_score*"
        }
        
        # Test 2: GET student stats
        Run-Test "GET /api/analytics/student-stats/101" {
            $response = Invoke-WebRequest -Uri "http://localhost:9004/api/analytics/student-stats/101" -ErrorAction SilentlyContinue
            $response.Content -like "*average_percentage*"
        }
        
        # Kill server
        Stop-Process -Id $process.Id -Force -ErrorAction SilentlyContinue
        
    } else {
        Write-Host "❌ Compilation failed" -ForegroundColor Red
        $failed += 2
    }
    
    # Cleanup
    Remove-Item "test_studenter.csv" -Force -ErrorAction SilentlyContinue
    Remove-Item "test_quiz_res.csv" -Force -ErrorAction SilentlyContinue
    
    Pop-Location
} else {
    Write-Host "⚠️  Oppgave 4 directory not found" -ForegroundColor Yellow
}

# ============================================================
# Summary
# ============================================================
Write-Host ""
Write-Host "================================================"
Write-Host "  Test Summary"
Write-Host "================================================"
Write-Host "Passed: $passed" -ForegroundColor Green
Write-Host "Failed: $failed" -ForegroundColor Red
Write-Host ""

if ($failed -eq 0) {
    Write-Host "🎉 All tests passed! Your code is ready to submit." -ForegroundColor Green
    exit 0
} else {
    Write-Host "⚠️  Some tests failed. Please review your code." -ForegroundColor Red
    exit 1
}
