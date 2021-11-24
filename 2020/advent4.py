with open("advent4.txt", "r") as file:
    input_ = file.read().split('\n\n')


better_input = [x for x in input_ if all(y in x for y in ['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid'])]
print(len(better_input))


better_input = [x.replace('\n', ',').replace(' ', ',') for x in better_input]
better_input = [dict(y.split(':') for y in x.split(",")) for x in better_input]


counter = 0
for x in better_input:
    if (1920 <= int(x['byr']) <= 2002 and
        2010 <= int(x['iyr']) <= 2020 and
        2020 <= int(x['eyr']) <= 2030 and
        x['ecl'] in ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'] and
        ((x['hgt'].endswith("cm") and 150 <= int(x['hgt'][:-2]) <= 196) or
         (x['hgt'].endswith("in") and 59 <= int(x['hgt'][:-2]) <= 76))):
        try:
            temp = int(x['pid'])
            if len(x['pid']) == 9:
                if x['hcl'].startswith('#') and int(x['hcl'][1:], 16):
                    counter += 1
        except:
            pass
        
print(counter)
