import bbcc
import bbcasm

if __name__ == "__main__":
    text = """
    // Comment
    int main() {
     char a;
     int c[5];
     return a;
    }
    """
    asm = bbcc.main(text)
    basic = bbcasm.asm_to_basic(asm)
    print(basic)
