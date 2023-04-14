int sum(int a, int b) {
    while (b > 0) {
        a = a + 1;
        b = b - 1;
    };
    return a;
}
int main() {
    int b;
    b = 10000;
    int result;
    result = 0;
    while(b > 0) {
        result = sum(result, 10000);
        b = b - 1;
    };
    return result;
}