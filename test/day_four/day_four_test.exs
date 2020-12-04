defmodule DayFour.DayFourTest do
  use ExUnit.Case

  @test_input "ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm

iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929

hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm

hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in"

  test "should read input and return list of strings" do
    list = Passport.parse_file(@test_input)

    assert length(list) == 4

    assert Enum.at(list, 0) == "ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm"
  end

  test "should parse passportsting to map" do
    p = Passport.parse_file(@test_input) |> Enum.at(0)

    expected = %{
      "ecl" => "gry",
      "pid" => "860033327",
      "eyr" => "2020",
      "hcl" => "#fffffd",
      "byr" => "1937",
      "iyr" => "2017",
      "cid" => "147",
      "hgt" => "183cm"
    }

    parsed = Passport.parse_passport(p)

    assert parsed == expected
  end

  test "first passport is valid" do
    passports =
      Passport.parse_file(@test_input)
      |> Enum.map(&Passport.parse_passport/1)

    valid = Passport.is_valid?(Enum.at(passports, 0))

    assert valid
  end

  test "second passport isn't valid" do
    passports =
      Passport.parse_file(@test_input)
      |> Enum.map(&Passport.parse_passport/1)

    valid = Passport.is_valid?(Enum.at(passports, 1))

    assert not valid
  end

  test "third passport is valid" do
    passports =
      Passport.parse_file(@test_input)
      |> Enum.map(&Passport.parse_passport/1)

    valid = Passport.is_valid?(Enum.at(passports, 2))

    assert valid
  end

  test "fourth passport is invalid" do
    passports =
      Passport.parse_file(@test_input)
      |> Enum.map(&Passport.parse_passport/1)

    valid = Passport.is_valid?(Enum.at(passports, 3))

    assert not valid
  end

  test "Get number of valid in test file" do
    num_valid =
      Passport.parse_file(@test_input)
      |> Enum.map(&Passport.parse_passport/1)
      |> Enum.map(&Passport.is_valid?/1)
      |> Enum.reduce(0, fn v, acc -> if v, do: acc + 1, else: acc end)

    assert num_valid == 2
  end

  test "Should handle part 1 file" do
    {:ok, input} = File.read("./test/day_four/day_four_input.txt")

    valid =
      Passport.parse_file(input)
      |> Enum.map(&Passport.parse_passport/1)
      |> Enum.filter(&Passport.is_valid?/1)

    assert length(valid) == 235
  end

  @invalid_present "eyr:1972 cid:100
hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

iyr:2019
hcl:#602927 eyr:1967 hgt:170cm
ecl:grn pid:012533040 byr:1946

hcl:dab227 iyr:2012
ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

hgt:59cm ecl:zzz
eyr:2038 hcl:74454a iyr:2023
pid:3556412378 byr:2007"

  test "invalid present rules" do
    valid =
      Passport.parse_file(@invalid_present)
      |> Enum.map(&Passport.parse_passport/1)
      |> Enum.filter(&Passport.is_valid?/1)
      |> Enum.filter(&Passport.is_present?/1)

    assert length(valid) == 0
  end

  @valid_present "pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
hcl:#623a2f

eyr:2029 ecl:blu cid:129 byr:1989
iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

hcl:#888785
hgt:164cm byr:2001 iyr:2015 cid:88
pid:545766238 ecl:hzl
eyr:2022

iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719"

  test "valid present rules" do
    valid =
      Passport.parse_file(@valid_present)
      |> Enum.map(&Passport.parse_passport/1)
      |> Enum.filter(&Passport.is_valid?/1)
      |> Enum.filter(&Passport.is_present?/1)

    assert length(valid) == 4
  end

  test "Should handle part 2 file" do
    {:ok, input} = File.read("./test/day_four/day_four_input.txt")

    valid =
      Passport.parse_file(input)
      |> Enum.map(&Passport.parse_passport/1)
      |> Enum.filter(&Passport.is_valid?/1)
      |> Enum.filter(&Passport.is_present?/1)

    assert length(valid) == 234
  end
end
