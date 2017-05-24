import bbcc

if __name__ == "__main__":
    text = """
    // Comment
    int main() {
     int a=1;
     a=2;
     return a*(1+2)*2;
    }
    """
    bbcc.main(text)
