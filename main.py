import bbcc

if __name__ == "__main__":
    text = """
    // Comment
    int main() {
     int a=1;
     return a*2;
    }
    """
    bbcc.main(text)
