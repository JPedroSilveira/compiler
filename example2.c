int getOne() {
    return 1;
}
int getZero() {
    return 0;
}
int decrease(int a) {
    return a - getOne();
}
int increase(int a) {
    return a + getOne();
}
int sum(int a, int b) {
    while (b > getZero()) {
        a = increase(a);
        b = decrease(b);
    };
    return a;
}
int multiply(int a, int b) {
    int result;
    result = getZero();
    while(b > getZero()) {
        result = sum(result, a);
        b = decrease(b);
    };
    return result;
}
int main() {
    return multiply(10000, 10000);
}