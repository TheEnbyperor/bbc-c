import bbcc

if __name__ == "__main__":
    text = """
    // Comment
    int main() {
     int a = 1, b = 2;
     a = 2;
     int c = a*b;
     return c;
    }
    """
    bbcc.main(text)
