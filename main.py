import bbcc

if __name__ == "__main__":
    text = """
    // Comment
    int main() {
     int d(int e);
     int a = 1, b = 2;
     a = 2;
     int c = a*b;
     d(c);
     return b;
    }
    """
    bbcc.main(text)
