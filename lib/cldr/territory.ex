defmodule Cldr.Territory do
  @moduledoc """
  Supports the CLDR Territories definitions which provide the localization of many
  territories.
  """

  require Cldr
  alias Cldr.LanguageTag

  @doc """
  Returns the available territories for a given locale.

  * `locale` is any configured locale. See `Cldr.known_locales()`. The default
    is `locale: Cldr.get_current_locale()`

  ## Example

      #=> Cldr.Territory.available_territories
      [:GS, :AL, :"155", :AM, :IL, :CH, :CG, :EG, :SO, :MT, :AS, :GL, :MU, :AR, :TV,
       :AI, :KR, :SA, :BI, :"054", :MY, :MW, :MS, :PM, :VC, :"143", :EC, :LK, :DG,
       :KH, :BR, :CR, :HN, :"HK-alt-short", :NU, :LV, :FR, :CC, :CI, :KI, :KZ, :TM,
       :KP, :MO, :TA, :BE, :BA, :ML, :XK, :US, ...]
  """
  @spec available_territories(String.t | LanguageTag.t) :: list(atom)
  def available_territories(locale \\ Cldr.get_current_locale())
  def available_territories(%LanguageTag{cldr_locale_name: cldr_locale_name}) do
    available_territories(cldr_locale_name)
  end

  @doc """
  Returns a map of all knwon territories in a given locale.

  * `locale` is any configured locale. See `Cldr.known_locales()`. The default
    is `locale: Cldr.get_current_locale()`

  ## Example

      #=> Cldr.Territory.known_territories
      %{GS: "South Georgia & South Sandwich Islands", AL: "Albania",
        "155": "Western Europe", AM: "Armenia", IL: "Israel", CH: "Switzerland",
        CG: "Congo - Brazzaville", EG: "Egypt", SO: "Somalia", MT: "Malta",
        AS: "American Samoa", GL: "Greenland", MU: "Mauritius", AR: "Argentina",
        TV: "Tuvalu", AI: "Anguilla", KR: "South Korea", SA: "Saudi Arabia",
        BI: "Burundi", "054": "Melanesia", MY: "Malaysia", MW: "Malawi",
        MS: "Montserrat", PM: "St. Pierre & Miquelon", VC: "St. Vincent & Grenadines",
        "143": "Central Asia", EC: "Ecuador", LK: "Sri Lanka", DG: "Diego Garcia",
        KH: "Cambodia", BR: "Brazil", CR: "Costa Rica", HN: "Honduras",
        "HK-alt-short": "Hong Kong", NU: "Niue", LV: "Latvia", FR: "France",
        CC: "Cocos (Keeling) Islands", CI: "Côte d’Ivoire", KI: "Kiribati",
        KZ: "Kazakhstan", TM: "Turkmenistan", KP: "North Korea",
        MO: "Macau SAR China", TA: "Tristan da Cunha", BE: "Belgium",
        BA: "Bosnia & Herzegovina", ML: "Mali", XK: "Kosovo", US: "United States",
        ...}
  """
  @spec known_territories(String.t | LanguageTag.t) :: map
  def known_territories(locale \\ Cldr.get_current_locale())
  def known_territories(%LanguageTag{cldr_locale_name: cldr_locale_name}) do
    available_territories(cldr_locale_name)
  end


  @doc """
  Localized string for the given territory code.
  Returns `{:ok, String.t}` if successful, otherwise `{:error, reason}`.

  * `locale` is any configured locale. See `Cldr.known_locales()`. The default
    is `locale: Cldr.get_current_locale()`

  ## Example

      iex> Cldr.Territory.from_territory_code(:GB)
      {:ok, "United Kingdom"}

      iex> Cldr.Territory.from_territory_code(:GB, "pt")
      {:ok, "Reino Unido"}
  """
  @spec from_territory_code(atom, String.t | LanguageTag.t) :: {:ok, String.t} | {:error, term}
  def from_territory_code(territory_code, locale \\ Cldr.get_current_locale())
  def from_territory_code(territory_code, locale) do
    territory_code
    |> atomize
    |> from_territory_code(locale)
  end
  def from_territory_code(territory_code, %LanguageTag{cldr_locale_name: cldr_locale_name}) do
    from_territory_code(territory_code, cldr_locale_name)
  end


  @doc """
  Localized string for the given territory code.
  The same as `from_territory_code/2`, but raises an error if it fails.


  * `locale` is any configured locale. See `Cldr.known_locales()`. The default
    is `locale: Cldr.get_current_locale()`

  ## Example

      iex> Cldr.Territory.from_territory_code!(:GB)
      "United Kingdom"

      iex> Cldr.Territory.from_territory_code!(:GB, "pt")
      "Reino Unido"
  """
  @spec from_territory_code!(atom, String.t | LanguageTag.t) :: String.t | term
  def from_territory_code!(territory_code, locale \\ Cldr.get_current_locale())
  def from_territory_code!(territory_code, %LanguageTag{cldr_locale_name: cldr_locale_name}) do
    from_territory_code!(territory_code, cldr_locale_name)
  end
  def from_territory_code!(territory_code, locale_name) do
    case from_territory_code(territory_code, locale_name) do
      {:ok, result}   -> result
      {:error, error} -> raise error
    end
  end

  @doc """
  Translate a localized string from one locale to another.
  Returns `{:ok, String.t}` if successful, otherwise `{:error, reason}`.

  * `locale` is any configured locale. See `Cldr.known_locales()`. The default
    is `locale: Cldr.get_current_locale()`

  ## Example

      iex> Cldr.Territory.translate_territory("Reino Unido", "pt")
      {:ok, "United Kingdom"}

      iex> Cldr.Territory.translate_territory("United Kingdom", "en", "pt")
      {:ok, "Reino Unido"}
  """
  @spec translate_territory(String.t, String.t, String.t | LanguageTag.t) :: String.t
  def translate_territory(localized_string, from_locale, to_locale \\ Cldr.get_current_locale())
  def translate_territory(localized_string, from_locale, %LanguageTag{cldr_locale_name: cldr_locale_name}) do
    translate_territory(localized_string, from_locale, cldr_locale_name)
  end

  @doc """
  The same as `translate_territory/3`, but raises an error if it fails.

  * `locale` is any configured locale. See `Cldr.known_locales()`. The default
    is `locale: Cldr.get_current_locale()`

  ## Example

      iex> Cldr.Territory.translate_territory!("Reino Unido", "pt")
      "United Kingdom"

      iex> Cldr.Territory.translate_territory!("United Kingdom", "en", "pt")
      "Reino Unido"
  """
  @spec translate_territory(String.t, String.t, String.t | LanguageTag.t) :: String.t
  def translate_territory!(localized_string, from_locale, to_locale \\ Cldr.get_current_locale())
  def translate_territory!(localized_string, from_locale, %LanguageTag{cldr_locale_name: cldr_locale_name}) do
    translate_territory!(localized_string, from_locale, cldr_locale_name)
  end
  def translate_territory!(localized_string, locale_from, locale_name) do
    case translate_territory(localized_string, locale_from, locale_name) do
      {:ok, result}   -> result
      {:error, error} -> raise error
    end
  end

  @children List.flatten(for {_k, v} <- Cldr.Config.territory_containment(), do: v)
  @doc """
  Lists parent(s) for the given territory code.
  Returns `{:ok, list}` if successful, otherwise `{:error, reason}`.

  * `locale` is any configured locale. See `Cldr.known_locales()`. The default
    is `locale: Cldr.get_current_locale()`

  ## Example

      iex> Cldr.Territory.parent(:GB)
      {:ok, [:"154", :EU, :UN]}
  """
  @spec parent(atom) :: {:ok, list(atom)} | {:error, term}
  def parent(territory_code) do
    @children
    |> Enum.member?(territory_code)
    |> case do
         true  -> {:ok, Cldr.Config.territory_containment()
                        |> Enum.filter(fn({_parent, values}) -> Enum.member?(values, territory_code) end)
                        |> Enum.map(fn({parent, _values}) -> parent end)
                        |> Enum.sort}

         false -> {:error, "territory code: #{territory_code} not available"}
       end
  end

  @doc """
  The same as `parent/1`, but raises an error if it fails.

  * `locale` is any configured locale. See `Cldr.known_locales()`. The default
    is `locale: Cldr.get_current_locale()`

  ## Example

      iex> Cldr.Territory.parent!(:GB)
      [:"154", :EU, :UN]
  """
  @spec parent!(atom) :: list(atom) | term()
  def parent!(territory_code) do
    case parent(territory_code) do
      {:ok, result}    -> result
      {:error, reason} -> raise reason
    end
  end


  @parents (for {k, _v} <- Cldr.Config.territory_containment(), do: k)
  @doc """
  Lists children(s) for the given territory code.
  Returns `{:ok, list}` if successful, otherwise `{:error, reason}`.

  * `locale` is any configured locale. See `Cldr.known_locales()`. The default
    is `locale: Cldr.get_current_locale()`

  ## Example

      iex> Cldr.Territory.children(:EU)
      {:ok,
       [:AT, :BE, :CY, :CZ, :DE, :DK, :EE, :ES, :FI, :FR, :GB, :GR, :HR, :HU, :IE,
        :IT, :LT, :LU, :LV, :MT, :NL, :PL, :PT, :SE, :SI, :SK, :BG, :RO]}
  """
  @spec children(atom) :: {:ok, list(atom)} | {:error, term()}
  def children(territory_code) do
    @parents
    |> Enum.member?(territory_code)
    |> case do
         true  -> {:ok, Cldr.Config.territory_containment()[territory_code]}
         false -> {:error, "territory code: #{territory_code} not available"}
       end
  end

  @doc """
  The same as `children/1`, but raises an error if it fails.

  * `locale` is any configured locale. See `Cldr.known_locales()`. The default
    is `locale: Cldr.get_current_locale()`

  ## Example

      iex> Cldr.Territory.children!(:EU)
      [:AT, :BE, :CY, :CZ, :DE, :DK, :EE, :ES, :FI, :FR, :GB, :GR, :HR, :HU, :IE, :IT,
       :LT, :LU, :LV, :MT, :NL, :PL, :PT, :SE, :SI, :SK, :BG, :RO]
  """
  @spec children!(atom) :: list(atom) | term()
  def children!(territory_code) do
    case children(territory_code) do
      {:ok, result}    -> result
      {:error, reason} -> raise reason
    end
  end

  @doc """
  Checks relationship between two territories, where the first argument is the `parent` and second the `child`.
  Returns `true` if successful, otherwise `false`.

  * `locale` is any configured locale. See `Cldr.known_locales()`. The default
    is `locale: Cldr.get_current_locale()`

  ## Example

      iex> Cldr.Territory.contains?(:EU, :DK)
      true
  """
  @spec contains?(atom, atom) :: true | false
  def contains?(parent, child) do
    @parents
    |> Enum.member?(parent)
    |> case do
         true  -> Enum.member?(Cldr.Config.territory_containment()[parent], child)
         false -> false
       end
  end

  @doc """
  Maps territory info for the given territory code.
  Returns `{:ok, map}` if successful, otherwise `{:error, reason}`.

  ## Example

      iex> Cldr.Territory.info(:GB)
      {:ok, %{currency: %{GBP: %{from: ~D[1694-07-27]}}, gdp: 2788000000000,
              language_population: %{"bn" => %{population_percent: 0.67},
                "cy" => %{official_status: "official_regional",
                  population_percent: 0.77}, "de" => %{population_percent: 6},
                "el" => %{population_percent: 0.34},
                "en" => %{official_status: "official", population_percent: 99},
                "fr" => %{population_percent: 19},
                "ga" => %{official_status: "official_regional",
                  population_percent: 0.026},
                "gd" => %{official_status: "official_regional",
                  population_percent: 0.099, writing_percent: 5},
                "it" => %{population_percent: 0.34},
                "ks" => %{population_percent: 0.19},
                "kw" => %{population_percent: 0.0031},
                "ml" => %{population_percent: 0.035},
                "pa" => %{population_percent: 0.79},
                "sco" => %{population_percent: 2.7, writing_percent: 5},
                "syl" => %{population_percent: 0.51},
                "yi" => %{population_percent: 0.049},
                "zh-Hant" => %{population_percent: 0.54}}, literacy_percent: 99,
              measurement_system: "metric", paper_size: "A4",
              population: 64430400, telephone_country_code: 44,
              temperature_measurement: "metric"}}
  """
  @spec info(atom) :: {:ok, map} | {:error, term()}
  def info(territory_code) do
    territory_code
    |> is_valid?
    |> case do
         true  -> {:ok, Cldr.Config.territory_info()[atomize(territory_code)]}
         false -> {:error, "territory code: #{territory_code} not available"}
       end
  end

  @doc """
  The same as `info/1`, but raises an error if it fails.

  ## Example

      iex> Cldr.Territory.info!(:GB)
      %{currency: %{GBP: %{from: ~D[1694-07-27]}}, gdp: 2788000000000,
        language_population: %{"bn" => %{population_percent: 0.67},
          "cy" => %{official_status: "official_regional",
            population_percent: 0.77}, "de" => %{population_percent: 6},
          "el" => %{population_percent: 0.34},
          "en" => %{official_status: "official", population_percent: 99},
          "fr" => %{population_percent: 19},
          "ga" => %{official_status: "official_regional",
            population_percent: 0.026},
          "gd" => %{official_status: "official_regional",
            population_percent: 0.099, writing_percent: 5},
          "it" => %{population_percent: 0.34},
          "ks" => %{population_percent: 0.19},
          "kw" => %{population_percent: 0.0031},
          "ml" => %{population_percent: 0.035},
          "pa" => %{population_percent: 0.79},
          "sco" => %{population_percent: 2.7, writing_percent: 5},
          "syl" => %{population_percent: 0.51},
          "yi" => %{population_percent: 0.049},
          "zh-Hant" => %{population_percent: 0.54}}, literacy_percent: 99,
        measurement_system: "metric", paper_size: "A4",
        population: 64430400, telephone_country_code: 44,
        temperature_measurement: "metric"}
  """
  @spec info!(atom) :: map | term()
  def info!(territory_code) do
    case info(territory_code) do
      {:ok, result}    -> result
      {:error, reason} -> raise reason
    end
  end

  @territory_codes Map.keys Cldr.Config.territory_info()
  @doc """
  Checks if the territory code is a valid ISO 3166-1 alpha-2 code.
  Returns `true` if successful, otherwise `false`.

  ## Example

      iex> Cldr.Territory.is_valid?(:GB)
      true
      iex> Cldr.Territory.is_valid?(:gb)
      true
      iex> Cldr.Territory.is_valid?("GB")
      true
      iex> Cldr.Territory.is_valid?("gb")
      true
      iex> Cldr.Territory.is_valid?(:zzz)
      false
      iex> Cldr.Territory.is_valid?("zzz")
      false
  """
  @spec is_valid?(atom | String.t) :: true | false
  def is_valid?(territory_code) do
    territory_code
    |> atomize
    |> valid?
  end

  @spec valid?(atom, list(atom)) :: true | false
  defp valid?(territory_code, territory_codes \\ @territory_codes) do
    territory_codes
    |> Enum.member?(territory_code)
  end

  @spec atomize(String.t | atom) :: atom
  defp atomize(territory_code) when is_binary(territory_code) do
    territory_code
    |> String.upcase
    |> String.to_atom
  end
  defp atomize(territory_code) when is_atom(territory_code) do
    territory_code
    |> Atom.to_string
    |> String.upcase
    |> String.to_atom
  end

  # Generate the functions that encapsulate the territory data from CDLR
  for locale_name <- Cldr.Config.known_locales() do
    territories = locale_name |> Cldr.Config.get_locale() |> Map.get(:territories)

    def available_territories(unquote(locale_name)) do
      unquote(Map.keys territories)
    end

    def known_territories(unquote(locale_name)) do
      unquote(Macro.escape(territories))
    end

    def from_territory_code(territory_code, unquote(locale_name)) do
      case is_valid?(territory_code) do
        false ->
          {:error, "territory code: #{territory_code} not available"}

        true  ->
          unquote(locale_name)
          |> Cldr.validate_locale()
          |> case do
               {:ok, %LanguageTag{cldr_locale_name: unquote(locale_name)}} ->
                 {:ok, Map.get(unquote(Macro.escape(territories)), territory_code)}

               error -> error
             end
      end
    end

    def translate_territory(localized_string, locale_from, unquote(locale_name)) do
      unquote(locale_name)
      |> Cldr.validate_locale()
      |> case do
           {:error, reason} ->
             {:error, reason}

           {:ok, %LanguageTag{cldr_locale_name: unquote(locale_name)}} ->
             locale_from
             |> Cldr.validate_locale()
             |> case do
                 {:error, reason} ->
                   {:error, reason}

                 {:ok, %LanguageTag{cldr_locale_name: locale}} ->
                   {territory_code, _} = locale
                                         |> Cldr.Config.get_locale()
                                         |> Map.get(:territories)
                                         |> Enum.find(fn {_k, v} -> v == localized_string end)

                   {:ok, Map.get(unquote(Macro.escape(territories)), territory_code)}
                end
         end
    end
  end

end
