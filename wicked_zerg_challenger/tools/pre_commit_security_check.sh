#!/bin/bash
# Git 커밋 전 민감한 정보 검사 스크립트
# 사용법: ./pre_commit_security_check.sh

set -e

echo "======================================================================"
echo "🔒 Git 커밋 전 민감한 정보 검사"
echo "======================================================================"
echo ""

# 검사할 패턴들
declare -a patterns=(
    "AIzaSy[A-Za-z0-9_-]{35}"  # Google API Key
    "sk-[A-Za-z0-9]{32,}"      # OpenAI API Key
    "xox[baprs]-[0-9]{10,13}-[0-9]{10,13}-[A-Za-z0-9]{24,32}"  # Slack Token
    "[0-9a-f]\{32\}"           # 일반적인 32자리 해시
    "[0-9a-f]\{40\}"           # 40자리 해시
    "AIzaSyBDdPWJyXs56AxeCPmqZpySFOVPjjSt_CM"  # 알려진 API 키
)

# 검사할 파일 확장자
declare -a extensions=("*.py" "*.kt" "*.java" "*.js" "*.ts" "*.md" "*.txt" "*.json" "*.yaml" "*.yml" "*.sh" "*.ps1" "*.bat")

# 검사 결과
found_issues=0
checked_files=0

echo "📁 스테이징된 파일 검사 중..."
echo ""

# Git 스테이징된 파일 가져오기
staged_files=$(git diff --cached --name-only --diff-filter=ACM 2>/dev/null || echo "")

if [ -z "$staged_files" ]; then
    echo "⚠️  Git 저장소가 아니거나 스테이징된 파일이 없습니다."
    echo "   모든 파일을 검사합니다..."
    echo ""
    
    # 모든 파일 검사
    for ext in "${extensions[@]}"; do
        while IFS= read -r -d '' file; do
            # .git, node_modules, venv 등 제외
            if [[ "$file" == *".git"* ]] || [[ "$file" == *"node_modules"* ]] || \
               [[ "$file" == *"venv"* ]] || [[ "$file" == *"__pycache__"* ]] || \
               [[ "$file" == *".gradle"* ]] || [[ "$file" == *"build"* ]]; then
                continue
            fi
            
            checked_files=$((checked_files + 1))
            
            for pattern in "${patterns[@]}"; do
                if grep -qE "$pattern" "$file" 2>/dev/null; then
                    line=$(grep -nE "$pattern" "$file" | head -1 | cut -d: -f1)
                    echo "🚨 민감한 정보 발견!"
                    echo "  파일: $file"
                    echo "  패턴: $pattern"
                    echo "  라인: $line"
                    echo ""
                    found_issues=$((found_issues + 1))
                fi
            done
        done < <(find . -type f -name "$ext" -print0 2>/dev/null)
    done
else
    # 스테이징된 파일만 검사
    while IFS= read -r file_path; do
        if [ -f "$file_path" ]; then
            checked_files=$((checked_files + 1))
            
            # 확장자 확인
            should_check=false
            for ext in "${extensions[@]}"; do
                if [[ "$file_path" == *"${ext#\*}" ]]; then
                    should_check=true
                    break
                fi
            done
            
            if [ "$should_check" = true ]; then
                for pattern in "${patterns[@]}"; do
                    if grep -qE "$pattern" "$file_path" 2>/dev/null; then
                        line=$(grep -nE "$pattern" "$file_path" | head -1 | cut -d: -f1)
                        preview=$(grep -E "$pattern" "$file_path" | head -1 | sed "s/$pattern/[REDACTED]/g" | cut -c1-80)
                        
                        echo "🚨 민감한 정보 발견!"
                        echo "  파일: $file_path"
                        echo "  패턴: $pattern"
                        echo "  라인: $line"
                        if [ -n "$preview" ]; then
                            echo "  미리보기: $preview"
                        fi
                        echo ""
                        found_issues=$((found_issues + 1))
                    fi
                done
            fi
        fi
    done <<< "$staged_files"
fi

echo ""
echo "======================================================================"
echo "검사 결과"
echo "======================================================================"
echo ""
echo "검사한 파일 수: $checked_files"
echo ""

if [ $found_issues -gt 0 ]; then
    echo "🚨 민감한 정보가 발견되었습니다!"
    echo ""
    echo "======================================================================"
    echo "❌ 커밋이 차단되었습니다!"
    echo "======================================================================"
    echo ""
    echo "조치 사항:"
    echo "  1. 위 파일들에서 민감한 정보를 제거하세요"
    echo "  2. 플레이스홀더로 대체하세요 (예: [YOUR_API_KEY])"
    echo "  3. 환경 변수나 설정 파일을 사용하세요"
    echo "  4. 다시 검사 후 커밋하세요"
    echo ""
    
    exit 1
else
    echo "✅ 민감한 정보가 발견되지 않았습니다."
    echo ""
    echo "안전하게 커밋할 수 있습니다."
    echo ""
    
    exit 0
fi
