import bbcc

if __name__ == "__main__":
    text = """
    // Comment
    int main() {
     int a = 2;
     int b = a==2;
     return a*b;
    }
    """
    bbcc.main(text)
