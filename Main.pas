unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.UITypes, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Imaging.pngimage, EquinoxControls;

type
  TCC=class(TForm)
    EditRed: TEdit;
    EditGreen: TEdit;
    EditBlue: TEdit;
    LabelR: TLabel;
    LabelG: TLabel;
    LabelB: TLabel;
    ColorSelector: TColorDialog;
    EditHEX: TEdit;
    LabelColor: TLabel;
    LabelNegativeColor: TLabel;
    LabelHEX: TLabel;
    EditNRed: TEdit;
    EditNGreen: TEdit;
    EditNBlue: TEdit;
    LabelNR: TLabel;
    LabelNG: TLabel;
    LabelNB: TLabel;
    EditNHEX: TEdit;
    LabelNHEX: TLabel;
    LabelTitle: TLabel;
    LabelAuthor: TLabel;
    MainIcon: TExHoverImage;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MainIconMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    procedure PickColor(Sender: TObject);
    function GetNegativeColor(const Value: TColor): TColor;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public

  end;

type
    TColorField=class(TCustomControl)
      private
       IsActive: Boolean;

       FTip: string;
       FSelectable: Boolean;

       function GetColor: TColor;
       function GetTextColor: TColor;

       procedure SetColor(const Value: TColor);
       procedure SetTip(const Value: string);
       procedure SetTextColor(const Value: TColor);
       procedure SetSelectable(const Value: Boolean);
      protected
       procedure Paint; override;
       procedure SetParent(AParent: TWinControl); override;

       procedure CMMouseenter(var Message: TMessage); message CM_MOUSEENTER;
       procedure CMMouseleave(var Message: TMessage); message CM_MOUSELEAVE;
      public
       constructor Create(AOwner: TComponent); override;

       property Color: TColor read GetColor write SetColor default 0;
       property Tip: string read FTip write SetTip;
       property TextColor: TColor read GetTextColor write SetTextColor;
       property Selectable: Boolean read FSelectable write SetSelectable default True;
    end;

var
  CC: TCC;
  SelectedColor: TColorField;
  NegativeColor: TColorField;

implementation

{$R *.dfm}
{$SetPEFlags IMAGE_FILE_RELOCS_STRIPPED}
{$SetPEFlags IMAGE_FILE_LINE_NUMS_STRIPPED}
{$SetPEFlags IMAGE_FILE_LOCAL_SYMS_STRIPPED}
{$SetPEFlags IMAGE_FILE_DEBUG_STRIPPED}
{$SetPEFlags IMAGE_FILE_EXECUTABLE_IMAGE}

constructor TColorField.Create(AOwner: TComponent);
begin
 inherited;
SetColor(0);
SetTextColor(clWhite);
FTip:='Izaberite boju...';
FSelectable:=True;
IsActive:=False;
Width:=128;
Height:=32;
end;

procedure TColorField.Paint;
var
   Field: TRect;
   Caption: string;
begin
 Field:=ClientRect;
 Caption:='';
 Canvas.Brush.Style:=bsSolid;
 Canvas.Brush.Color:=Color;
 Canvas.Font.Style:=[fsBold];
 Canvas.Font.Name:='Calibri';
 Canvas.Font.Size:=10;
 Canvas.Font.Color:=TextColor;
 Caption:=Tip;
 Canvas.Pen.Color:=0;
 If Color=0 Then
  Canvas.Pen.Color:=clWhite;
 Canvas.Pen.Width:=2;
 Canvas.Rectangle(ClientRect);

 If IsActive Then
  begin
   Caption:='Izaberi boju...';
   Canvas.TextRect(Field, Caption, [tfSingleLine, tfCenter, tfVerticalCenter]);
  end;
end;

function TColorField.GetColor;
begin
 Result:=Canvas.Brush.Color;
end;

procedure TColorField.SetColor(const Value: TColor);
begin
If Color<>Value Then
 begin
  Canvas.Brush.Color:=Value;
  Repaint;
 end;
end;

function TColorField.GetTextColor;
begin
 Result:=Canvas.Font.Color;
end;

procedure TColorField.SetTextColor(const Value: TColor);
begin
If TextColor<>Value Then
 begin
  Canvas.Font.Color:=Value;
  Repaint;
 end;
end;

procedure TColorField.SetParent(AParent: TWinControl);
begin
 inherited;
If Assigned(Parent) Then
 Width:=Parent.Width;
end;

procedure TColorField.SetTip(const Value: string);
begin
If Tip<>Value Then
 begin
  FTip:=Value;
  Repaint;
 end;
end;

procedure TColorField.SetSelectable(const Value: Boolean);
begin
 FSelectable:=Value;
 Repaint;
end;

procedure TColorField.CMMouseenter(var Message: TMessage);
begin
 inherited;

If Selectable Then
 begin
  Cursor:=crHandPoint;
  IsActive:=True;
  Repaint;
 end;
end;

procedure TColorField.CMMouseleave(var Message: TMessage);
begin
 inherited;
Cursor:=crDefault;

If Selectable Then
 begin
  IsActive:=False;
  Repaint;
 end;
end;

procedure TCC.PickColor(Sender: TObject);
var
   Negative: TColor;
   StrColor: string;
begin
 If ColorSelector.Execute Then
  begin
   Negative:=GetNegativeColor(ColorSelector.Color);
   SelectedColor.Color:=ColorSelector.Color;
   SelectedColor.TextColor:=Negative;
   StrColor:=ColorToString(SelectedColor.Color);
   NegativeColor.Color:=Negative;
   If StrColor.Contains('$') Then
    EditHEX.Text:='#'+Copy(StrColor, 4, 9);
   StrColor:=ColorToString(Negative);
   EditRed.Text:=IntToStr(GetRValue(ColorSelector.Color));
   EditGreen.Text:=IntToStr(GetGValue(ColorSelector.Color));
   EditBlue.Text:=IntToStr(GetBValue(ColorSelector.Color));
   If StrColor.Contains('$') Then
    EditNHEX.Text:='#'+Copy(StrColor, 4, 9);
   EditNRed.Text:=IntToStr(GetRValue(Negative));
   EditNGreen.Text:=IntToStr(GetGValue(Negative));
   EditNBlue.Text:=IntToStr(GetBValue(Negative));
  end;
end;

procedure TCC.CreateParams(var Params: TCreateParams);
const
  CS_DROPSHADOW = $00020000;
begin
 inherited;
 Params.Style:=WS_POPUP;
 Params.WindowClass.style:=Params.WindowClass.style Or CS_DROPSHADOW;
end;

procedure TCC.FormCreate(Sender: TObject);
begin
 SetWindowRgn(Handle, CreateRoundRectRgn(0, 0, ClientWidth, ClientHeight, 16, 16), True);
 SelectedColor:=TColorField.Create(Application);
 SelectedColor.Parent:=Self;
 SelectedColor.Left:=0;
 SelectedColor.Top:=MainIcon.Top+MainIcon.Height+10;;
 SelectedColor.OnClick:=PickColor;
 NegativeColor:=TColorField.Create(Application);
 NegativeColor.Parent:=Self;
 NegativeColor.Left:=0;
 NegativeColor.Top:=EditBlue.Top+EditBlue.Height+10;
 NegativeColor.Selectable:=False;
end;

procedure TCC.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
If Key=vkM Then
  Application.Minimize;

If Key=vkEscape Then
 Close;
end;

procedure TCC.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
const
     SC_DRAG=$F012;
begin
 ReleaseCapture;
 Perform(WM_SYSCOMMAND, SC_DRAG, 0);
end;

procedure TCC.FormShow(Sender: TObject);
begin
 ShowWindow(Handle, SW_SHOW);
 SetFocus;
end;

function TCC.GetNegativeColor(const Value: TColor): TColor;
begin
 Result:=RGB(255-GetRValue(Value), 255-GetGValue(Value), 255-GetBValue(Value));
end;

procedure TCC.MainIconMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 MouseDown(Button, Shift, X, Y);
end;

end.
