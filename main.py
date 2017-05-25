import bbcc

if __name__ == "__main__":
    text = """
    // Comment
    int main() {
     char a;
     int c[5];
     return a;
    }
    """
    bbcc.main(text)
