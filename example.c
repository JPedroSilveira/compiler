int b;
int goodbye() {
    int a;
    a = 2;
    return a;
}
int hello() {
    int a;
    a = goodbye();
    return a;
}
int main() {
    int a;
    a = hello() * goodbye() * 10;
    return a;
}