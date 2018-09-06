import wx
import wx.grid


class EmulatorFrame(wx.Frame):
    def __init__(self, *args, **kw):
        super().__init__(*args, **kw)

        self.SetSizeHints(wx.DefaultSize, wx.DefaultSize)

        b_sizer1 = wx.BoxSizer(wx.HORIZONTAL)
        b_sizer2 = wx.BoxSizer(wx.VERTICAL)

        self.m_staticText1 = wx.StaticText(self, wx.ID_ANY, u"Registers", wx.DefaultPosition, wx.DefaultSize, 0)
        self.m_staticText1.SetFont(
            wx.Font(wx.NORMAL_FONT.GetPointSize(), wx.FONTFAMILY_DEFAULT, wx.FONTSTYLE_NORMAL, wx.FONTWEIGHT_BOLD,
                    False, wx.EmptyString))

        b_sizer2.Add(self.m_staticText1, 0, wx.ALL, 5)

        g_sizer1 = wx.GridSizer(0, 2, 0, 0)

        self.m_staticText2 = wx.StaticText(self, wx.ID_ANY, u"R0 (Return)", wx.DefaultPosition, wx.DefaultSize, 0)
        g_sizer1.Add(self.m_staticText2, 0, wx.ALL, 5)

        self.r0_val = wx.StaticText(self, wx.ID_ANY, u"0x00000000", wx.DefaultPosition, wx.DefaultSize, 0)
        g_sizer1.Add(self.r0_val, 0, wx.ALL, 5)

        self.m_staticText21 = wx.StaticText(self, wx.ID_ANY, u"R1", wx.DefaultPosition, wx.DefaultSize, 0)
        g_sizer1.Add(self.m_staticText21, 0, wx.ALL, 5)

        self.r1_val = wx.StaticText(self, wx.ID_ANY, u"0x00000000", wx.DefaultPosition, wx.DefaultSize, 0)
        g_sizer1.Add(self.r1_val, 0, wx.ALL, 5)

        self.m_staticText22 = wx.StaticText(self, wx.ID_ANY, u"R2", wx.DefaultPosition, wx.DefaultSize, 0)
        g_sizer1.Add(self.m_staticText22, 0, wx.ALL, 5)

        self.r2_val = wx.StaticText(self, wx.ID_ANY, u"0x00000000", wx.DefaultPosition, wx.DefaultSize, 0)
        g_sizer1.Add(self.r2_val, 0, wx.ALL, 5)

        self.m_staticText23 = wx.StaticText(self, wx.ID_ANY, u"R3", wx.DefaultPosition, wx.DefaultSize, 0)
        g_sizer1.Add(self.m_staticText23, 0, wx.ALL, 5)

        self.r3_val = wx.StaticText(self, wx.ID_ANY, u"0x00000000", wx.DefaultPosition, wx.DefaultSize, 0)
        g_sizer1.Add(self.r3_val, 0, wx.ALL, 5)

        self.m_staticText24 = wx.StaticText(self, wx.ID_ANY, u"R4", wx.DefaultPosition, wx.DefaultSize, 0)
        g_sizer1.Add(self.m_staticText24, 0, wx.ALL, 5)

        self.r4_val = wx.StaticText(self, wx.ID_ANY, u"0x00000000", wx.DefaultPosition, wx.DefaultSize, 0)
        g_sizer1.Add(self.r4_val, 0, wx.ALL, 5)

        self.m_staticText25 = wx.StaticText(self, wx.ID_ANY, u"R5", wx.DefaultPosition, wx.DefaultSize, 0)
        g_sizer1.Add(self.m_staticText25, 0, wx.ALL, 5)

        self.r5_val = wx.StaticText(self, wx.ID_ANY, u"0x00000000", wx.DefaultPosition, wx.DefaultSize, 0)
        g_sizer1.Add(self.r5_val, 0, wx.ALL, 5)

        self.m_staticText251 = wx.StaticText(self, wx.ID_ANY, u"R6", wx.DefaultPosition, wx.DefaultSize, 0)
        g_sizer1.Add(self.m_staticText251, 0, wx.ALL, 5)

        self.r6_val = wx.StaticText(self, wx.ID_ANY, u"0x00000000", wx.DefaultPosition, wx.DefaultSize, 0)
        g_sizer1.Add(self.r6_val, 0, wx.ALL, 5)

        self.m_staticText252 = wx.StaticText(self, wx.ID_ANY, u"R7", wx.DefaultPosition, wx.DefaultSize, 0)
        g_sizer1.Add(self.m_staticText252, 0, wx.ALL, 5)

        self.r7_val = wx.StaticText(self, wx.ID_ANY, u"0x00000000", wx.DefaultPosition, wx.DefaultSize, 0)
        g_sizer1.Add(self.r7_val, 0, wx.ALL, 5)

        self.m_staticText253 = wx.StaticText(self, wx.ID_ANY, u"R8", wx.DefaultPosition, wx.DefaultSize, 0)
        g_sizer1.Add(self.m_staticText253, 0, wx.ALL, 5)

        self.r8_val = wx.StaticText(self, wx.ID_ANY, u"0x00000000", wx.DefaultPosition, wx.DefaultSize, 0)
        g_sizer1.Add(self.r8_val, 0, wx.ALL, 5)

        self.m_staticText254 = wx.StaticText(self, wx.ID_ANY, u"R9", wx.DefaultPosition, wx.DefaultSize, 0)
        g_sizer1.Add(self.m_staticText254, 0, wx.ALL, 5)

        self.r9_val = wx.StaticText(self, wx.ID_ANY, u"0x00000000", wx.DefaultPosition, wx.DefaultSize, 0)
        g_sizer1.Add(self.r9_val, 0, wx.ALL, 5)

        self.m_staticText255 = wx.StaticText(self, wx.ID_ANY, u"R10", wx.DefaultPosition, wx.DefaultSize, 0)
        g_sizer1.Add(self.m_staticText255, 0, wx.ALL, 5)

        self.r10_val = wx.StaticText(self, wx.ID_ANY, u"0x00000000", wx.DefaultPosition, wx.DefaultSize, 0)
        g_sizer1.Add(self.r10_val, 0, wx.ALL, 5)

        self.m_staticText2555 = wx.StaticText(self, wx.ID_ANY, u"R11", wx.DefaultPosition, wx.DefaultSize, 0)
        g_sizer1.Add(self.m_staticText2555, 0, wx.ALL, 5)

        self.r11_val = wx.StaticText(self, wx.ID_ANY, u"0x00000000", wx.DefaultPosition, wx.DefaultSize, 0)
        g_sizer1.Add(self.r11_val, 0, wx.ALL, 5)

        self.m_staticText256 = wx.StaticText(self, wx.ID_ANY, u"R12 (Base pointer)",
                                             wx.DefaultPosition, wx.DefaultSize, 0)
        g_sizer1.Add(self.m_staticText256, 0, wx.ALL, 5)

        self.r12_val = wx.StaticText(self, wx.ID_ANY, u"0x00000000", wx.DefaultPosition, wx.DefaultSize, 0)
        g_sizer1.Add(self.r12_val, 0, wx.ALL, 5)

        self.m_staticText257 = wx.StaticText(self, wx.ID_ANY, u"R13 (Status)", wx.DefaultPosition, wx.DefaultSize, 0)
        g_sizer1.Add(self.m_staticText257, 0, wx.ALL, 5)

        self.r13_val = wx.StaticText(self, wx.ID_ANY, u"0x00000000", wx.DefaultPosition, wx.DefaultSize, 0)
        g_sizer1.Add(self.r13_val, 0, wx.ALL, 5)

        self.m_staticText258 = wx.StaticText(self, wx.ID_ANY, u"R14 (Stack pointer)",
                                             wx.DefaultPosition, wx.DefaultSize, 0)
        g_sizer1.Add(self.m_staticText258, 0, wx.ALL, 5)

        self.r14_val = wx.StaticText(self, wx.ID_ANY, u"0x00000000", wx.DefaultPosition, wx.DefaultSize, 0)
        g_sizer1.Add(self.r14_val, 0, wx.ALL, 5)

        self.m_staticText259 = wx.StaticText(self, wx.ID_ANY, u"R15 (Program counter)",
                                             wx.DefaultPosition, wx.DefaultSize, 0)
        g_sizer1.Add(self.m_staticText259, 0, wx.ALL, 5)

        self.r15_val = wx.StaticText(self, wx.ID_ANY, u"0x00000000", wx.DefaultPosition, wx.DefaultSize, 0)
        g_sizer1.Add(self.r15_val, 0, wx.ALL, 5)

        b_sizer2.Add(g_sizer1, 1, wx.EXPAND, 5)
        b_sizer1.Add(b_sizer2, 1, 0, 5)

        b_sizer3 = wx.BoxSizer(wx.VERTICAL)
        b_sizer4 = wx.BoxSizer(wx.HORIZONTAL)

        self.m_button1 = wx.Button(self, wx.ID_ANY, u"Step Into", wx.DefaultPosition, wx.DefaultSize, 0)
        b_sizer4.Add(self.m_button1, 1, wx.ALL, 5)

        self.m_button2 = wx.Button(self, wx.ID_ANY, u"Step Over", wx.DefaultPosition, wx.DefaultSize, 0)
        b_sizer4.Add(self.m_button2, 1, wx.ALL, 5)

        self.m_button7 = wx.Button(self, wx.ID_ANY, u"Run", wx.DefaultPosition, wx.DefaultSize, 0)
        b_sizer4.Add(self.m_button7, 0, wx.ALL, 5)

        b_sizer3.Add(b_sizer4, 0, wx.EXPAND, 5)

        self.m_staticText11 = wx.StaticText(self, wx.ID_ANY, u"Current Insruction",
                                            wx.DefaultPosition, wx.DefaultSize, 0)
        self.m_staticText11.SetFont(
            wx.Font(wx.NORMAL_FONT.GetPointSize(), wx.FONTFAMILY_DEFAULT, wx.FONTSTYLE_NORMAL, wx.FONTWEIGHT_BOLD,
                    False, wx.EmptyString))
        b_sizer3.Add(self.m_staticText11, 0, wx.ALL, 5)

        self.cur_inst = wx.StaticText(self, wx.ID_ANY, wx.EmptyString, wx.DefaultPosition, wx.DefaultSize, 0)
        b_sizer3.Add(self.cur_inst, 0, wx.ALL, 5)

        self.m_staticText111 = wx.StaticText(self, wx.ID_ANY, u"Breakpoints", wx.DefaultPosition, wx.DefaultSize, 0)

        self.m_staticText111.SetFont(
            wx.Font(wx.NORMAL_FONT.GetPointSize(), wx.FONTFAMILY_DEFAULT, wx.FONTSTYLE_NORMAL, wx.FONTWEIGHT_BOLD,
                    False, wx.EmptyString))
        b_sizer3.Add(self.m_staticText111, 0, wx.ALL, 5)

        self.breakpoints = wx.ListBox(self, wx.ID_ANY, wx.DefaultPosition, wx.DefaultSize, [], 0)
        b_sizer3.Add(self.breakpoints, 1, wx.ALL | wx.EXPAND, 5)

        b_sizer5 = wx.BoxSizer(wx.HORIZONTAL)

        self.m_textCtrl1 = wx.TextCtrl(self, wx.ID_ANY, wx.EmptyString, wx.DefaultPosition, wx.DefaultSize, 0)
        b_sizer5.Add(self.m_textCtrl1, 0, wx.ALL, 5)

        self.m_button3 = wx.Button(self, wx.ID_ANY, u"Add", wx.DefaultPosition, wx.DefaultSize, 0)
        b_sizer5.Add(self.m_button3, 0, wx.ALL, 5)

        self.m_button6 = wx.Button(self, wx.ID_ANY, u"Remove", wx.DefaultPosition, wx.DefaultSize, 0)
        b_sizer5.Add(self.m_button6, 0, wx.ALL, 5)

        b_sizer3.Add(b_sizer5, 0, wx.EXPAND, 5)

        self.m_staticText1111 = wx.StaticText(self, wx.ID_ANY, u"Exports", wx.DefaultPosition, wx.DefaultSize, 0)
        self.m_staticText1111.SetFont(
            wx.Font(wx.NORMAL_FONT.GetPointSize(), wx.FONTFAMILY_DEFAULT, wx.FONTSTYLE_NORMAL, wx.FONTWEIGHT_BOLD,
                    False, wx.EmptyString))

        b_sizer3.Add(self.m_staticText1111, 0, wx.ALL, 5)

        self.labels = wx.ListBox(self, wx.ID_ANY, wx.DefaultPosition, wx.DefaultSize, [], 0)
        b_sizer3.Add(self.labels, 1, wx.ALL | wx.EXPAND, 5)
        b_sizer6 = wx.BoxSizer(wx.HORIZONTAL)

        self.m_button4 = wx.Button(self, wx.ID_ANY, u"Break on label", wx.DefaultPosition, wx.DefaultSize, 0)
        b_sizer6.Add(self.m_button4, 0, wx.ALL, 5)

        b_sizer3.Add(b_sizer6, 0, wx.EXPAND, 5)

        b_sizer7 = wx.BoxSizer(wx.HORIZONTAL)

        self.m_button5 = wx.Button(self, wx.ID_ANY, u"Open File", wx.DefaultPosition, wx.DefaultSize, 0)
        b_sizer7.Add(self.m_button5, 0, wx.ALL, 5)

        b_sizer3.Add(b_sizer7, 0, wx.EXPAND, 5)

        b_sizer1.Add(b_sizer3, 1, wx.EXPAND, 5)

        b_sizer8 = wx.BoxSizer(wx.VERTICAL)

        self.m_staticText112 = wx.StaticText(self, wx.ID_ANY, u"Memory View", wx.DefaultPosition, wx.DefaultSize, 0)
        self.m_staticText112.Wrap(-1)

        self.m_staticText112.SetFont(
            wx.Font(wx.NORMAL_FONT.GetPointSize(), wx.FONTFAMILY_DEFAULT, wx.FONTSTYLE_NORMAL, wx.FONTWEIGHT_BOLD,
                    False, wx.EmptyString))

        b_sizer8.Add(self.m_staticText112, 0, wx.ALL, 5)

        b_sizer9 = wx.BoxSizer(wx.HORIZONTAL)

        self.m_staticText1122 = wx.StaticText(self, wx.ID_ANY, u"Memory location", wx.DefaultPosition, wx.DefaultSize,
                                              0)
        self.m_staticText1122.Wrap(-1)

        b_sizer9.Add(self.m_staticText1122, 0, wx.ALL | wx.EXPAND, 5)

        self.mem_page = wx.TextCtrl(self, wx.ID_ANY, wx.EmptyString, wx.DefaultPosition, wx.DefaultSize, 0)
        b_sizer9.Add(self.mem_page, 1, wx.ALL | wx.EXPAND, 5)

        self.m_button8 = wx.Button(self, wx.ID_ANY, u"View Page", wx.DefaultPosition, wx.DefaultSize, 0)
        b_sizer9.Add(self.m_button8, 0, wx.ALL, 5)

        b_sizer8.Add(b_sizer9, 0, wx.EXPAND, 5)

        self.m_grid1 = wx.grid.Grid(self, wx.ID_ANY, wx.DefaultPosition, wx.DefaultSize, 0)

        # Grid
        self.m_grid1.CreateGrid(16, 16)
        self.m_grid1.EnableEditing(False)
        self.m_grid1.EnableGridLines(False)
        self.m_grid1.EnableDragGridSize(False)
        self.m_grid1.SetMargins(0, 0)

        # Columns
        self.m_grid1.AutoSizeColumns()
        self.m_grid1.EnableDragColMove(False)
        self.m_grid1.EnableDragColSize(False)
        self.m_grid1.SetColLabelValue(0, u"0")
        self.m_grid1.SetColLabelValue(1, u"1")
        self.m_grid1.SetColLabelValue(2, u"2")
        self.m_grid1.SetColLabelValue(3, u"3")
        self.m_grid1.SetColLabelValue(4, u"4")
        self.m_grid1.SetColLabelValue(5, u"5")
        self.m_grid1.SetColLabelValue(6, u"6")
        self.m_grid1.SetColLabelValue(7, u"7")
        self.m_grid1.SetColLabelValue(8, u"8")
        self.m_grid1.SetColLabelValue(9, u"9")
        self.m_grid1.SetColLabelValue(10, u"A")
        self.m_grid1.SetColLabelValue(11, u"B")
        self.m_grid1.SetColLabelValue(12, u"C")
        self.m_grid1.SetColLabelValue(13, u"D")
        self.m_grid1.SetColLabelValue(14, u"E")
        self.m_grid1.SetColLabelValue(15, u"F")
        self.m_grid1.SetColLabelAlignment(wx.ALIGN_CENTRE, wx.ALIGN_CENTRE)

        # Rows
        self.m_grid1.AutoSizeRows()
        self.m_grid1.EnableDragRowSize(False)
        self.m_grid1.SetRowLabelAlignment(wx.ALIGN_CENTRE, wx.ALIGN_CENTRE)

        # Label Appearance

        # Cell Defaults
        self.m_grid1.SetDefaultCellAlignment(wx.ALIGN_LEFT, wx.ALIGN_TOP)
        b_sizer8.Add(self.m_grid1, 1, wx.ALL | wx.EXPAND, 5)

        b_sizer1.Add(b_sizer8, 1, wx.EXPAND, 5)

        self.SetSizer(b_sizer1)
        self.Layout()

        self.Centre(wx.BOTH)

        # Connect Events
        self.m_button1.Bind(wx.EVT_BUTTON, self.step_into)
        self.m_button2.Bind(wx.EVT_BUTTON, self.step_over)
        self.m_button7.Bind(wx.EVT_BUTTON, self.run)
        self.m_button3.Bind(wx.EVT_BUTTON, self.add_breakpoint)
        self.m_button6.Bind(wx.EVT_BUTTON, self.remove_breakpoint)
        self.m_button4.Bind(wx.EVT_BUTTON, self.break_on_label)
        self.m_button5.Bind(wx.EVT_BUTTON, self.open_file)
        self.m_button8.Bind(wx.EVT_BUTTON, self.view_page)

    def step_into(self, event):
        event.Skip()

    def step_over(self, event):
        event.Skip()

    def run(self, event):
        event.Skip()

    def add_breakpoint(self, event):
        event.Skip()

    def remove_breakpoint(self, event):
        event.Skip()

    def break_on_label(self, event):
        event.Skip()

    def open_file(self, event):
        event.Skip()

    def view_page(self, event):
        event.Skip()
