program test(intput, output); // dgdsgdgfgsfd

type
    Date = record
            k1 :char;
            k2 :integer;
            k3 : record
                k31 : char;
                k32 : integer;
                k33 : record
                    k331: char;
                    k332 : integer
                end;
                k34 : integer
            end;
        k4 : integer
    end;


var
    a, a1, a11 : array[1..1] of integer;
    a2 : array[1..10, 1..10,1..100]  of integer;
    x, y, z : integer;  
    D1 : Date;
    kkk : record
        k1 :char;
        k2 :integer;
        k3 : record
            k31 : char;
            k32 : integer;
            k33 : record
                k331: char;
                k332 : integer
            end;
            k34 : integer
        end;
        k4 : integer
    end;


procedure pro1(a : integer; b : real);
    const
        CONPRO1 = 1;
    var
        t : integer;
    begin
        writeln(1, 2, 3);
    end;

function func2(a, b:integer) : integer;
    const
        SONF = 12;
    begin
        for x := 1 to 9 do
            y := 1;
        if x = 1 then
            y := 3;
        kkk.k3.k33.k333 := 1;
        D1.k3.k33.k332  := 1;
    end;


begin
    kkk.k3.k33.k332 := 1;
    kkk.k3.k33.k333 := 1;
    D1.k3.k33.k332  := 1;
    D1.k3.k33.k333  := 1;
    a2[2,3] := 2;
    a2[2,3,3] := 2;
    a2[2,3,3,2] := 2;
    pro1(1,2);
    pro1(1,2,3);
    pro(1,23);
    func2(2,2);
end.