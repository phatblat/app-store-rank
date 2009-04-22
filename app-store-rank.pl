#! /usr/bin/perl
# Autofetch category rank

package appStoreRank;

use warnings;
use strict;

# FSWB
my $appName = "Full Screen Web Browser";
my $appID = 303154925;
# my $categoryName = "Top Overall";
my $categoryName = "Utilities";

my %categories = (
    "Top Overall"           => 25204,
    "Books"                 => 25470,
    "Business"              => 25148,
    "Education"             => 25156,
    "Entertainment"         => 25164,
    "Finance"               => 25172,
    "Healthcare & Fitness"  => 25188,
    "Lifestyle"             => 25196,
    "Medical"               => 26321,
    "Music"                 => 25212,
    "Navigation"            => 25220,
    "News"                  => 25228,
    "Photography"           => 25236,
    "Productivity"          => 25244,
    "Reference"             => 25252,
    "Social Networking"     => 25260,
    "Sports"                => 25268,
    "Travel"                => 25276,
    "Utilities"             => 25284,
    "Weather"               => 25292,
    "All Games"             => 25180,
    "Games/Action"          => 26341,
    "Games/Adventure"       => 26351,
    "Games/Arcade"          => 26361,
    "Games/Board"           => 26371,
    "Games/Card"            => 26381,
    "Games/Casino"          => 26341,
    "Games/Dice"            => 26341,
    "Games/Educational"     => 26411,
    "Games/Family"          => 26421,
    "Games/Kids"            => 26431,
    "Games/Music"           => 26441,
    "Games/Puzzle"          => 26451,
    "Games/Racing"          => 26461,
    "Games/Role Playing"    => 26471,
    "Games/Simulation"      => 26481,
    "Games/Sports"          => 26491,
    "Games/Strategy"        => 26501,
    "Games/Trivia"          => 26511,
    "Games/Word"            => 26521,
);


# my %appRankInCategoryForUS  = getAppRankingInCategoryForUS($appID, $categories{$categoryName});
my %appRankInTopCategory    = getAppRankingInCategoryForWorld($appID, $categories{"Top Overall"});
my %appRankInCategory       = getAppRankingInCategoryForWorld($appID, $categories{$categoryName});

my $top100OverallCount      = countTopRanking(100, %appRankInTopCategory);
my $top20CategoryCount      = countTopRanking(20, %appRankInCategory);
my $top100CategoryCount     = countTopRanking(100, %appRankInCategory);

print "\n-------------------------------------------------------------------------------\n";
print "$appName ranking around the world as of " . localtime();
print "\n-------------------------------------------------------------------------------\n\n";

# US Ranking
# print "$appName Ranking in $categoryName Category in US: " . $appRankInCategoryForUS{"United States"} . "\n\n";
if ($appRankInTopCategory{"United States"}) {
    print "Top 100 overall in US: " . 
        $appRankInTopCategory{"United States"} . "\n\n";
}
if ($appRankInCategory{"United States"}) {
    print "$categoryName category in US: " . 
        $appRankInCategory{"United States"} . "\n\n";
}

print "Top 100 overall in $top100OverallCount countries\n";
print printSortedAndFilteredTopRanking(100, %appRankInTopCategory) . "\n";

print "Top 20 $categoryName in $top20CategoryCount countries\n";
# print printSortedAndFilteredTopRanking(20, %appRankInCategory) . "\n";

print "Top 100 $categoryName in $top100CategoryCount countries\n";
print printSortedAndFilteredTopRanking(100, %appRankInCategory) . "\n";




# print "$appName Ranking in Category $categoryName:\n";
# printHash(%appRankInCategoryForUS);
# 
# print "$appName Ranking in Category Top Overall:\n";
# printHash(%appRankInTopCategory);
# 
# print "$appName Ranking in Category $categoryName:\n";
# printHash(%appRankInCategory);


# Testing
# print countTopRanking(20, %{{"United States" => 20, "Slovenia" => 1}}) . "\n";
# print printSortedAndFilteredTopRanking(20, %{{"United States" => 20, "Slovenia" => 1}}) . "\n";


#
# Subroutines
#

sub printHash {
    my %hash = @_;
    while (my ($key, $value) = each(%hash)) {
        print "$key: $value\n";
    }
}

# $topNum is the minimum rank number you want to include in the count
# %ranks is a hash of string keys with numberic values: "country"=>99
sub countTopRanking {
    my ($topNum, %ranks) = @_;
    my $total = 0;
    my @array = map(($_ <= $topNum ? 1 : 0), values %ranks);
    # print $_ for @array;
    ($total += $_) for @array;
    return $total;
}


# $topNum is the minimum rank number you want to include in the count
# %ranks is a hash of string keys with numberic values: "country"=>99
sub printSortedAndFilteredTopRanking {
    my ($topNum, %ranks) = @_;
    # Get list of keys sorted by hash value
    my @countries = sort { $ranks{$a} <=> $ranks{$b} } keys %ranks;
    # Filter the list by min rank
    # my @filteredKeys = map {  $_ if ($ranks{$_} <= $topNum) } @keys;
    # for my $key (@filteredKeys) {
    for my $country (@countries) {
        if ($ranks{$country} <= $topNum) {
            # print $key . ': ' . $ranks{$key} . "\n";
            printf("%-20s %3s\n", $country, $ranks{$country});
        }
    }
}


sub getAppRankingInCategoryForUS {
    my ($appID, $categoryID) = @_;
    my ($country, $storeID);
    my %appRankInCategory;
    $country = "United States";
    $storeID = 143441;
    
    if (my $rank = fetchAppCategoryRankForCountry($appID, $categoryID, $country, $storeID)) {
        $appRankInCategory{$country} = $rank;
    }
    print "done\n";
    
    return %appRankInCategory;
}


sub getAppRankingInCategoryForWorld {
    my ($appID, $categoryID) = @_;
    my %appRankInCategory;
    my %appStore = (
        143441 => "United States",
        143505 => "Argentina",
        143460 => "Australia",
        143446 => "Belgium",
        143503 => "Brazil",
        143455 => "Canada",
        143483 => "Chile",
        143465 => "China",
        143501 => "Colombia",
        143495 => "Costa Rica",
        143494 => "Croatia",
        143489 => "Czech Republic",
        143458 => "Denmark",
        143443 => "Deutschland",
        143506 => "El Salvador",
        143454 => "Espana",
        143447 => "Finland",
        143442 => "France",
        143448 => "Greece",
        143504 => "Guatemala",
        143463 => "Hong Kong",
        143482 => "Hungary",
        143467 => "India",
        143476 => "Indonesia",
        143449 => "Ireland",
        143491 => "Israel",
        143450 => "Italia",
        143466 => "Korea",
        143493 => "Kuwait",
        143497 => "Lebanon",
        143451 => "Luxembourg",
        143473 => "Malaysia",
        143468 => "Mexico",
        143452 => "Nederland",
        143461 => "New Zealand",
        143457 => "Norway",
        143445 => "Osterreich",
        143477 => "Pakistan",
        143485 => "Panama",
        143507 => "Peru",
        143474 => "Phillipines",
        143478 => "Poland",
        143453 => "Portugal",
        143498 => "Qatar",
        143487 => "Romania",
        143469 => "Russia",
        143479 => "Saudi Arabia",
        143459 => "Schweitz/Suisse",
        143464 => "Singapore",
        143496 => "Slovakia",
        143499 => "Slovenia",
        143472 => "South Africa",
        143486 => "Sri Lanka",
        143456 => "Sweden",
        143470 => "Taiwan",
        143475 => "Thailand",
        143480 => "Turkey",
        143481 => "United Arab Emirates",
        143444 => "United Kingdom",
        143502 => "Venezuela",
        143471 => "Vietnam",
        143462 => "Japan"
    );
    
    # Print out a progress bar size
    # print '|';
    # my $size = keys(%appStore) - 2;
    # for (1..$size) {
    #     print '-';
    # }
    # print '|';
    
    while (my ($storeID, $country) = each(%appStore)) {
        # print "$storeID\n";
        # my $country = $appStores{$storeID};
        if (my $rank = fetchAppCategoryRankForCountry($appID, $categoryID, $country, $storeID)) {
            # print $rank . "\n";
            $appRankInCategory{$country} = $rank;
        }
    }
    print "done\n";
    
    return %appRankInCategory;
}


sub fetchAppCategoryRankForCountry {
    my ($myAppID, $categoryID, $country, $storeID) = @_;
    my ($rank, $found);
    # Show some progress
    print ".";
    my @top100 = fetchTop100InCategory($storeID, $categoryID);
    for (my $i = 0; $i < $#top100; $i += 3) {
        $rank = $top100[$i];
        my $appID = $top100[$i+1];
        my $title = $top100[$i+2];
        # print $rank . " " . $title . " " . $appID . "\n";
        if ($appID == $myAppID) {
            $found = 1;
            # print $rank . " " . $title . "\n";
            last;
        }
    }
    if ($found) {
        # $rank = "n/a";
        # print "$country: $rank\n";
        return $rank;
    }
}


sub fetchTop100InCategory {
    my($storeID, $categoryID) = @_;
    
    # 30 == paid
    # 27 == free
    my $popId = 30;

    my $fetchcmd = qq{curl -s -A "iTunes/4.2 (Macintosh; U; PPC Mac OS X 10.2" -H "X-Apple-Store-Front: $storeID-1" 'http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewTop?id=$categoryID&popId=$popId' };
    # Might need to pipe through these...
    # | gunzip
    # | xmllint --format -

    my $doc = `$fetchcmd`;

    # DEBUG: read from local file
    # my $filename = '/Users/phatblat/tmp/itunes_utilties_top100.xml';
    # open (FILE, "<", $filename)  or  die "Failed to read file $filename : $! \n";
    # my $doc;
    # {
    #     local $/;
    #     $doc = <FILE>;
    # }
    # close(FILE);
    
    my @top100;
    while ($doc =~ m#(\d+)\.\</SetFontStyle\>.*?viewSoftware\?id=(\d+).*?draggingName="([^"]+)"#gs) {
        # 1 => rank
        # 2 => app ID
        # 3 => app name
        # print "$1 $3 $2 \n";
        push(@top100, ($1, $2, $3));
    }

    return @top100;
}

