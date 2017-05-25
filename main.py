import bbcc

if __name__ == "__main__":
    text = """
    // Comment
    int main() {
     char a = 'a';
     int b = a++;
     return a;
    }
    """
    bbcc.main(text)
